//
//  PieceDbUpdater.swift
//  PracticeLogger
//
//  Created on 3/15/25.

import ApolloGQL

class PieceDbUpdater {
    private let apollo = Network.shared.apollo
    private let piece: EditablePiece
    private let pieceId: ApolloGQL.BigInt?
    private var attempts = 0
    private let maxAttempts = 2

    /// Initialize with an EditablePiece for insert operations
    init(piece: EditablePiece) {
        self.piece = piece
        pieceId = nil
    }

    /// Initialize with a pieceId and EditablePiece for update operations
    init(pieceId: ApolloGQL.BigInt, piece: EditablePiece) {
        self.piece = piece
        self.pieceId = pieceId
    }

    /// Save the piece - automatically determines whether to insert or update
    func save() async throws -> PieceDetails {
        let pieceDetails: PieceDetails

        if let pieceId = pieceId {
            pieceDetails = try await updatePiece(pieceId: pieceId)
        } else {
            pieceDetails = try await insertPiece()
        }

        // 👇 Invalidate the cached Piece object
        try? await Network.shared.apollo.store.withinReadWriteTransaction { transaction in
            try transaction.removeObject(for: "Piece:\(pieceDetails.id)")
        }

        return pieceDetails
    }

    // MARK: - Insert Operations

    private func insertPiece() async throws -> PieceDetails {
        let inputObject = try await piece.toGraphQLInput()
        print("🔵 Inserting piece:", inputObject)

        let pieceDetails = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PieceDetails, Error>) in
            apollo.perform(mutation: InsertNewPieceMutation(input: [inputObject])) { result in
                switch result {
                case let .success(graphQlResult):
                    if let errors = graphQlResult.errors {
                        let errorMessage = errors.map { $0.message ?? "" }.joined(separator: ", ")
                        continuation.resume(throwing: RuntimeError("GraphQL errors: \(errorMessage)"))
                        return
                    }

                    guard let collection = graphQlResult.data?.insertIntoPieceCollection else {
                        continuation.resume(throwing: RuntimeError("Missing insertIntoPiecesCollection in response"))
                        return
                    }

                    guard !collection.records.isEmpty else {
                        continuation.resume(throwing: RuntimeError("No records returned from insertion"))
                        return
                    }

                    guard let insertedPiece = collection.records.first else {
                        continuation.resume(throwing: RuntimeError("Failed to get inserted piece from records"))
                        return
                    }

                    continuation.resume(returning: insertedPiece.fragments.pieceDetails)

                case let .failure(error):
                    continuation.resume(throwing: RuntimeError("Failed to insert piece: \(error.localizedDescription)"))
                }
            }
        }

        // Only insert movements if there are any
        if !piece.movements.isEmpty {
            return try await insertMovements(forPieceId: pieceDetails.id)
        }

        return pieceDetails
    }

    private func insertMovements(forPieceId pieceId: ApolloGQL.BigInt) async throws -> PieceDetails {
        let movementsInput = piece.movements.map { movement in
            MovementInsertInput(
                pieceId: .some(pieceId),
                name: movement.name != nil ? .some(movement.name!) : .null,
                number: movement.number != nil ? .some(movement.number!) : .null,
                keySignature: movement.keySignature != nil ? .some(movement.keySignature!) : .null,
                nickname: movement.nickname != nil ? .some(movement.nickname!) : .null,
                downloadUrl: movement.downloadUrl != nil ? .some(movement.downloadUrl!) : .null
            )
        }

        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PieceDetails, Error>) in
            apollo.perform(mutation: CreateMovementsMutation(input: movementsInput)) { result in
                switch result {
                case let .success(movementResult):
                    if let errors = movementResult.errors {
                        if let error = errors.first {
                            continuation.resume(throwing: RuntimeError("""
                            Movement insertion failed for piece \(pieceId):
                            Error: \(error.message ?? "Unknown error")
                            Inputs: \(movementsInput)
                            """))
                        }
                        return
                    }

                    self.fetchPieceDetails(pieceId, continuation: continuation)

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    // MARK: - Update Operations

    private func updatePiece(pieceId: ApolloGQL.BigInt) async throws -> PieceDetails {
        let updateInput = piece.toGraphQLUpdateInput()
        let filter = GraphQLNullable(PieceFilter(id: .some(BigIntFilter(eq: .some(pieceId)))))

        print("🔵 Updating piece \(pieceId):", updateInput)

        let pieceDetails = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PieceDetails, Error>) in
            apollo.perform(mutation: UpdatePieceMutation(set: updateInput, filter: filter)) { result in
                switch result {
                case let .success(graphQlResult):
                    if let errors = graphQlResult.errors {
                        let errorMessage = errors.map { $0.message ?? "" }.joined(separator: ", ")
                        continuation.resume(throwing: RuntimeError("GraphQL errors: \(errorMessage)"))
                        return
                    }

                    guard let collection = graphQlResult.data?.updatePieceCollection else {
                        continuation.resume(throwing: RuntimeError("Missing updatePieceCollection in response"))
                        return
                    }

                    guard !collection.records.isEmpty else {
                        continuation.resume(throwing: RuntimeError("No records returned from update"))
                        return
                    }

                    guard let updatedPiece = collection.records.first else {
                        continuation.resume(throwing: RuntimeError("Failed to get updated piece from records"))
                        return
                    }

                    continuation.resume(returning: updatedPiece.fragments.pieceDetails)

                case let .failure(error):
                    continuation.resume(throwing: RuntimeError("Failed to update piece: \(error.localizedDescription)"))
                }
            }
        }

        // Handle movements update
        return try await updateMovements(forPieceDetails: pieceDetails)
    }

    private func updateMovements(forPieceDetails pieceDetails: PieceDetails) async throws -> PieceDetails {
        // First, let's fetch existing movements to determine what needs to be updated or created
        let existingMovementEdges = pieceDetails.movements?.edges ?? []
        let existingMovementIds = existingMovementEdges.map { $0.node.id }

        let movementsToUpdate = piece.movements.compactMap { movement -> (MovementUpdateInput, GraphQLNullable<MovementFilter>)? in

            // Check if any existing movement has this ID
            let matchingMovement = existingMovementIds.contains(movement.id)
            if !matchingMovement {
                return nil
            }
            // Handle GraphQLEnum for keySignature
            var keySignatureValue: GraphQLNullable<GraphQLEnum<KeySignatureType>> = .null
            if let keySignature = movement.keySignature {
                keySignatureValue = .some(keySignature)
            }

            let updateInput = MovementUpdateInput(
                name: movement.name != nil ? .some(movement.name!) : .null,
                number: movement.number != nil ? .some(movement.number!) : .null,
                keySignature: keySignatureValue,
                nickname: movement.nickname != nil ? .some(movement.nickname!) : .null,
                downloadUrl: movement.downloadUrl != nil ? .some(movement.downloadUrl!) : .null
            )

            let filter = GraphQLNullable<MovementFilter>(MovementFilter(id: .some(BigIntFilter(eq: .some(movement.id)))))
            let updateInputTyped: MovementUpdateInput = updateInput
            let filterTyped: GraphQLNullable<MovementFilter> = filter

            return (updateInputTyped, filterTyped)
        }

        for (updateInput, filter) in movementsToUpdate {
            _ = try await updateMovement(set: updateInput, filter: filter)
        }

        return try await fetchPieceDetails(pieceDetails.id)
    }

    private func updateMovement(set: MovementUpdateInput, filter: GraphQLNullable<MovementFilter>) async throws {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            apollo.perform(mutation: UpdateMovementsMutation(set: set, filter: filter)) { result in

                switch result {
                case let .success(graphQlResult):
                    if let errors = graphQlResult.errors {
                        let errorMessage = errors.map { $0.message ?? "" }.joined(separator: ", ")
                        continuation.resume(throwing: RuntimeError("GraphQL errors updating movement: \(errorMessage)"))
                        return
                    }

                    continuation.resume(returning: ())

                case let .failure(error):
                    continuation.resume(throwing: RuntimeError("Failed to update movement: \(error.localizedDescription)"))
                }
            }
        }
    }

    private func insertNewMovements(inputs: [MovementInsertInput]) async throws {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
            apollo.perform(mutation: CreateMovementsMutation(input: inputs)) { result in
                switch result {
                case let .success(graphQlResult):
                    if let errors = graphQlResult.errors {
                        let errorMessage = errors.map { $0.message ?? "" }.joined(separator: ", ")
                        continuation.resume(throwing: RuntimeError("GraphQL errors inserting movements: \(errorMessage)"))
                        return
                    }

                    continuation.resume(returning: ())

                case let .failure(error):
                    continuation.resume(throwing: RuntimeError("Failed to insert movements: \(error.localizedDescription)"))
                }
            }
        }
    }

    // MARK: - Shared Utilities

    private func fetchPieceDetails(_ pieceId: ApolloGQL.BigInt, continuation: CheckedContinuation<PieceDetails, Error>? = nil) {
        apollo.fetch(query: PiecesQuery(
            pieceFilter: PieceFilter(
                id: .some(BigIntFilter(eq: .some(pieceId))))
        ), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case let .success(pieceResult):
                if let completePiece = pieceResult.data?.pieceCollection?.edges.first {
                    if let continuation = continuation {
                        continuation.resume(returning: completePiece.node.fragments.pieceDetails)
                    }
                } else {
                    if let continuation = continuation {
                        continuation.resume(throwing: RuntimeError("Complete piece not found"))
                    }
                }

            case let .failure(error):
                if let continuation = continuation {
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    private func fetchPieceDetails(_ pieceId: ApolloGQL.BigInt) async throws -> PieceDetails {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PieceDetails, Error>) in
            fetchPieceDetails(pieceId, continuation: continuation)
        }
    }
}
