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

            // Perform mutation on a background thread
            let pieceDetails = try await withCheckedThrowingContinuation { continuation in

                Network.shared.apollo.perform(mutation: InsertNewPieceMutation(input: [inputObject])) { result in
                    switch result {
                    case .success(let graphQlResult):
                        if let insertedPiece = graphQlResult.data?.insertIntoPiecesCollection?.records.first {
                            // Access the fragment
                            let pieceDetails = insertedPiece.fragments.pieceDetails
                            continuation.resume(returning: pieceDetails) // Return the piece details
                        } else {
                            print("ERROR IN PIECE INPUT", result)
                            continuation.resume(throwing: RuntimeError("No pieces were inserted"))
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }

            return pieceDetails
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
