//
//  PieceInserter.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/1/25.

import ApolloGQL

class PieceInserter {
    private let apollo = Network.shared.apollo
    private let piece: EditablePiece
    private var attempts = 0
    private let maxAttempts = 2
    
    init(piece: EditablePiece) {
        self.piece = piece
    }
    
    func insert() async throws -> PieceDetails {
        do {
            let pieceDetails = try await insertPiece()
            
            // Only insert movements if there are any
            if !piece.movements.isEmpty {
                return try await insertMovements(forPieceId: pieceDetails.id)
            }
            
            return pieceDetails
        } catch let error as RuntimeError where error.description.contains("extra keys [\"imslpPieceId\"]") {
            attempts += 1
            if attempts < maxAttempts {
                print("🔵 Schema mismatch detected, clearing cache and retrying...")
                try await Network.shared.apollo.clearCache()
                return try await insert() // Recursive retry
            }
            throw error
        }
    }
    
    private func insertPiece() async throws -> PieceDetails {
        let inputObject = piece.toGraphQLInput()
        print("🔵 Inserting piece:", inputObject)
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PieceDetails, Error>) in
            apollo.perform(mutation: InsertNewPieceMutation(input: [inputObject])) { result in
                switch result {
                case .success(let graphQlResult):
                    // First check for GraphQL errors
                    if let errors = graphQlResult.errors {
                        let errorMessage = errors.map { $0.message ?? "" }.joined(separator: ", ")
                        continuation.resume(throwing: RuntimeError("GraphQL errors: \(errorMessage)"))
                        return
                    }
                    
                    // Then check the response structure
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
                    
                case .failure(let error):
                    continuation.resume(throwing: RuntimeError("Failed to insert piece: \(error.localizedDescription)"))
                }
            }
        }
    }
    
    private func insertMovements(forPieceId pieceId: ApolloGQL.BigInt) async throws -> PieceDetails {
        let movementsInput = piece.movements.map { movement in
            MovementInsertInput(
                pieceId: pieceId != nil ? .some(pieceId) : .null,
                name: movement.name != nil ? .some(movement.name!) : .null,
                number: movement.number != nil ? .some(movement.number!) : .null
            )
        }
        
        print("🔵 Attempting to insert \(movementsInput.count) movements for piece \(pieceId)")
        
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<PieceDetails, Error>) in
            apollo.perform(mutation: CreateMovementsMutation(input: movementsInput)) { result in
                switch result {
                case .success(let movementResult):
                    if let errors = movementResult.errors {
                        if let error = errors.first {
                            continuation.resume(throwing: RuntimeError("""
                            Movement insertion failed for piece \(pieceId):
                            Error: \(error.message)
                            Inputs: \(movementsInput)
                            """))
                        }
                        return
                    }
                    
                    // Fetch final piece with movements
                    self.fetchPieceDetails(pieceId, continuation: continuation)
                    
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func fetchPieceDetails(_ pieceId: ApolloGQL.BigInt, continuation: CheckedContinuation<PieceDetails, Error>) {
        apollo.fetch(query: PiecesQuery(
            pieceFilter: PieceFilter(
                id: .some(BigIntFilter(eq: .some(pieceId))))
        )) { result in
            switch result {
            case .success(let pieceResult):
                if let completePiece = pieceResult.data?.pieceCollection?.edges.first {
                    continuation.resume(returning: completePiece.node.fragments.pieceDetails)
                } else {
                    continuation.resume(throwing: RuntimeError("Complete piece not found"))
                }
            case .failure(let error):
                continuation.resume(throwing: error)
            }
        }
    }
}
