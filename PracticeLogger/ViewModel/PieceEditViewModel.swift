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
    @Published var piece: Piece
    init(piece: Piece) {
        self.piece = piece
    }

    func insertPiece(piece: Piece) async throws -> PieceDetails {
        do {
            // Find or create composer
            let composer: Composer = try await Database.client
                .rpc("find_or_create_composer", params: ["name": piece.composer?.name])
                .execute()
                .value

            piece.composer?.id = composer.id
            let inputObject = piece.toGraphQLInput()

            // Use a continuation to handle async mutation and fetch
            return try await withCheckedThrowingContinuation { continuation in
                Network.shared.apollo.perform(mutation: InsertNewPieceMutation(input: [inputObject])) { result in
                    switch result {
                    case .success(let graphQlResult):
                        if let insertedPiece = graphQlResult.data?.insertIntoPiecesCollection?.records.first {
                            let pieceDetails = insertedPiece.fragments.pieceDetails
                            let pieceId = pieceDetails.id
                            let movementsInput = piece.movements.map { movement in
                                MovementsInsertInput(
                                    pieceId: .some(pieceDetails.id),
                                    name: .some(movement.name),
                                    number: .some(movement.number)
                                )
                            }

                            // Perform the movement mutation
                            Network.shared.apollo.perform(mutation: CreateMovementsMutation(input: movementsInput)) { result in
                                switch result {
                                case .success(let movementResult):
                                    print(movementResult)
                                    if let _ = movementResult.data?.insertIntoMovementsCollection?.records {
                                        // Fetch the complete piece after movements are created
                                        Network.shared.apollo.fetch(query: PieceQuery(pieceFilter: PiecesFilter(id: .some(UUIDFilter(eq: .some(pieceId)))))) { result in
                                            switch result {
                                            case .success(let pieceResult):
                                                if let completePiece = pieceResult.data?.piecesCollection?.edges.first {
                                                    let completePieceDetails = completePiece.node.fragments.pieceDetails
                                                    continuation.resume(returning: completePieceDetails)
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
        } catch {
            throw error
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        piece.movements.move(fromOffsets: source, toOffset: destination)
        for index in piece.movements.indices {
            piece.movements[index].number = index + 1
        }
        piece = piece
    }

    func updateMovementName(at index: Int, newName: String) {
        guard index < piece.movements.count else { return } // Ensure index is within bounds
        piece.movements[index].name = newName
    }

    func isDuplicate(piece: Piece) async throws -> Piece? {
        do {
            guard let catalogue_number = piece.catalogue_number, let catalogue_type = piece.catalogue_type else {
                return nil
            }
            let currentUserID = try Database.getCurrentUser()?.id.uuidString
            let response: Piece = try await Database.client.rpc("find_duplicate_piece", params: ["catalogue_number": String(catalogue_number), "catalogue_type": catalogue_type.rawValue, "user_id": currentUserID, "composer_name": piece.composer?.name]).execute().value

            return response
        } catch {
            // Handle errors
            switch error {
            case let decodingError as DecodingError:
                // Check if the error is of type valueNotFound
                if case DecodingError.valueNotFound = decodingError {
                    return nil
                } else {
                    print("Decoding error:", decodingError)
                    return nil
                }
            default:

                print("Error in isDuplicate function:", error)
                return nil
            }
        }
    }
}

struct MetadataInformation: Decodable {
    var catalogue_number: Int?
    var catalogue_type: CatalogueType?
    var format: Format?
    var key_signature: KeySignatureType?
    var tonality: KeySignatureTonality?
    var nickname: String?
}
