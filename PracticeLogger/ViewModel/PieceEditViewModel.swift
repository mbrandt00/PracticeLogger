//
//  PieceEditViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/28/24.
//

import Foundation
import Supabase
class PieceEditViewModel: ObservableObject {
    @Published var piece: Piece
    init(piece: Piece) {
        self.piece = piece
    }
    func insertPiece(piece: Piece) async throws {
        do {
            // Attempt to create the piece
            try await Database.createPiece(piece: piece) // {
            //                print("YAY")
            //            } else {
            //                throw InsertionError.pieceCreationFailed
            //            }
            //        } catch {
            //            // Handle any other errors
            //            throw error
            //        }
        }
    }

    func move(from source: IndexSet, to destination: Int) {
        piece.movements.move(fromOffsets: source, toOffset: destination)
        for (index) in piece.movements.indices {
            piece.movements[index].number = index + 1
        }
        self.piece = piece
    }

    func updateMovementName(at index: Int, newName: String) {
        guard index < piece.movements.count else { return } // Ensure index is within bounds
        piece.movements[index].name = newName

    }

    func addMetadata(to piece: Piece) async throws -> Piece? {
        do {

            if let response: MetadataInformation = try await Database.client.rpc("parse_piece_metadata", params: ["work_name": piece.workName]).select().single().execute().value {
                dump(response)
                piece.catalogue_number =  response.catalogue_number
                piece.catalogue_type = response.catalogue_type
                piece.key_signature = response.key_signature
                piece.tonality = response.tonality
                piece.format = response.format
            }
            dump(piece)
            return piece
        } catch {
            print("Error getting piece information:", error)
            return nil
        }
    }

//    func isDuplicate(piece: Piece) async throws -> Piece? {
//        do {
//            guard let catalogue_number = piece.catalogue_number, let catalogue_type = piece.catalogue_type else {
//                return nil
//            }
//
//            let currentUserID = try await String(Database.getCurrentUser().id.uuidString)
//
//            // Attempt to decode the response
//            let response: Piece = try await Database.client.rpc("find_duplicate_piece", params: ["catalogue_number": String(catalogue_number), "catalogue_type": catalogue_type.rawValue, "user_id": currentUserID, "composer_name": piece.composer.name ]).execute().value
//            dump(response)
//            return response
//        } catch {
//            // Handle errors
//            switch error {
//            case let decodingError as DecodingError:
//                // Check if the error is of type valueNotFound
//                if case DecodingError.valueNotFound(_, _) = decodingError {
//                    // Return nil if no value was found
//                    return nil
//                } else {
//                    // Handle other decoding errors
//                    print("Decoding error:", decodingError)
//                    return nil
//                }
//            default:
//                // Handle other types of errors
//                print("Error in isDuplicate function:", error)
//                return nil
//            }
//        }
//    }
}

enum InsertionError: Error {
    case pieceCreationFailed
}

struct MetadataInformation: Decodable {
    var catalogue_number: Int?
    var catalogue_type: CatalogueType?
    var format: Format?
    var key_signature: KeySignatureType?
    var tonality: KeySignatureTonality?
}
