//
//  PieceEditViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/28/24.
//

import ApolloAPI
import ApolloGQL
import Foundation
import Supabase

class PieceEditViewModel: ObservableObject {
    @Published var editablePiece: EditablePiece
    
    init(piece: PieceDetails) {
        self.editablePiece = EditablePiece(from: piece)
    }
    
    func insertPiece() async throws -> PieceDetails {
        do {
            let inputObject = editablePiece.toGraphQLInput()

            dump(inputObject)
            // Use a continuation to handle async mutation and fetch
            return try await withCheckedThrowingContinuation { continuation in
                Network.shared.apollo.perform(mutation: InsertNewPieceMutation(input: [inputObject])) { result in
                    switch result {
                    case .success(let graphQlResult):
                        if let insertedPiece = graphQlResult.data?.insertIntoPiecesCollection?.records.first {
                            let pieceDetails = insertedPiece.fragments.pieceDetails
                            let pieceId = pieceDetails.id
                            let movementsInput = self.editablePiece.movements.map { movement in
                                MovementsInsertInput(
                                    pieceId: .some(pieceDetails.id),
                                    name: movement.name != nil ? .some(movement.name!) : .null,
                                    number: movement.number != nil ? .some(movement.number!) : .null
                                )
                            }

                            // Perform the movement mutation
                            Network.shared.apollo.perform(mutation: CreateMovementsMutation(input: movementsInput)) { result in
                                switch result {
                                case .success(let movementResult):
                                    print(movementResult)
                                    if let movementInsertResult = movementResult.data?.insertIntoMovementsCollection?.records {
                                        // Fetch the complete piece after movements are created
                                        Network.shared.apollo.fetch(query: PiecesQuery(pieceFilter: PiecesFilter(id: .some(BigIntFilter(eq: .some(pieceId)))))) { result in
                                            switch result {
                                            case .success(let pieceResult):
                                                if let completePiece = pieceResult.data?.piecesCollection?.edges.first {
                                                    let completePieceDetails = completePiece.node.fragments.pieceDetails
                                                    Task {
                                                        do {
                                                            let result = try await Database.client
                                                                .rpc("update_piece_fts_manual", params: ["target_id": pieceId])
                                                                .execute()

                                                            continuation.resume(returning: completePieceDetails)
                                                        } catch {
                                                            continuation.resume(throwing: RuntimeError("Error updating FTS: \(error.localizedDescription)"))
                                                        }
                                                    }
                                                } else {
                                                    continuation.resume(throwing: RuntimeError("Complete piece not found"))
                                                }
                                            case .failure(let error):
                                                print("Error fetching complete piece:", error)
                                                continuation.resume(throwing: RuntimeError(error.localizedDescription))
                                            }
                                        }
                                    } else {
                                        continuation.resume(throwing: RuntimeError("No movement details inserted"))
                                    }
                                case .failure(let error):
                                    print("Error creating movements:", error)
                                    continuation.resume(throwing: RuntimeError(error.localizedDescription))
                                }
                            }
                        } else {
                            print("No pieces were inserted")
                            continuation.resume(throwing: RuntimeError("No pieces were inserted"))
                        }
                    case .failure(let error):
                        print("Error inserting piece:", error)
                        continuation.resume(throwing: RuntimeError(error.localizedDescription))
                    }
                }
            }
        } catch (let error) {
            throw error
        }
    }
    
    func updateMovement(at index: Int, newName: String) {
        print("⚡️ Updating movement at index: \(index)")
        let movements = editablePiece.movements
        
        // Update directly on the existing array
        editablePiece.movements[index].name = newName
        
        // Force a view update by reassigning the array
        let updatedMovements = editablePiece.movements
        editablePiece.movements = updatedMovements
        
        print("✅ Movement updated successfully")
    }
    
    func deleteMovement(at index: Int) {
        print("Deleting movement at index:", index)
        var movements = editablePiece.movements
        
        movements.remove(at: index)
        
        // Update numbering
        print("Updating numbers for remaining movements")
        for (idx, movement) in movements.enumerated() {
            movement.number = idx + 1
        }
        
        print("Final movements count:", movements.count)
        editablePiece.movements = movements
    }
    
    func moveMovements(from source: IndexSet, to destination: Int) {
        var movements = editablePiece.movements
        movements.move(fromOffsets: source, toOffset: destination)
        
        // Update numbering
        for (idx, movement) in movements.enumerated() {
            movement.number = idx + 1
        }
        
        editablePiece.movements = movements
    }
}

class EditablePiece: ObservableObject {
    @Published var id: ApolloGQL.BigInt
    @Published var workName: String
    @Published var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>?
    @Published var catalogueNumber: Int?
    @Published var nickname: String?
    @Published var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?
    @Published var format: GraphQLEnum<PieceFormat>?
    @Published var movements: [EditableMovement] = []
    @Published var composer: EditableComposer?
    @Published var composerId: ApolloGQL.BigInt?
    @Published var compositionYear: Int?
    @Published var imslpUrl: String?
    @Published var wikipediaUrl: String?
    @Published var instrumentation: [String?]?
    
    init(from piece: PieceDetails) {
        self.id = piece.id
        self.workName = piece.workName
        self.catalogueType = piece.catalogueType
        self.catalogueNumber = piece.catalogueNumber
        self.nickname = piece.nickname
        self.keySignature = piece.keySignature
        self.instrumentation = piece.instrumentation
        self.format = piece.format
        self.compositionYear = piece.compositionYear
        self.composerId = piece.composerId
        self.wikipediaUrl = piece.wikipediaUrl
        self.imslpUrl = piece.imslpUrl
        if let movements = piece.movements?.edges {
            self.movements = movements.compactMap { edge in
                EditableMovement(from: edge.node)
            }.sorted { ($0.number ?? 0) < ($1.number ?? 0) }
        }
        
        if let composer = piece.composer {
            self.composer = EditableComposer(from: composer)
        }
    }
}

class EditableMovement: Identifiable, ObservableObject {
    @Published var id: ApolloGQL.BigInt
    @Published var name: String?
    @Published var number: Int?
    
    init(from node: PieceDetails.Movements.Edge.Node) {
        self.id = node.id
        self.name = node.name
        self.number = node.number
    }
}

class EditableComposer {
    var name: String
    var id: ApolloGQL.BigInt?
    
    init(from composer: PieceDetails.Composer) {
        self.name = composer.name
    }
    
    init(name: String) {
        self.name = name
    }
}

extension EditablePiece {
    func toGraphQLInput() -> PiecesInsertInput {
        PiecesInsertInput(
            workName: .some(workName),
            composerId: composerId.map { .some($0) } ?? .null,
            nickname: nickname.map { .some($0) } ?? .null,
            format: format.map { .some($0) } ?? .null,
            keySignature: keySignature.map { .some($0) } ?? .null,
            catalogueType: catalogueType.map { .some($0) } ?? .null,
            catalogueNumber: catalogueNumber.map { .some($0) } ?? .null,
            compositionYear: compositionYear.map { .some($0) } ?? .null,
            wikipediaUrl: wikipediaUrl.map { .some($0) } ?? .null,
            instrumentation: instrumentation.map { .some($0) } ?? .null,
            imslpUrl: imslpUrl.map { .some($0) } ?? .null,
            imslpPieceId: .some(id)
        )
    }
}
