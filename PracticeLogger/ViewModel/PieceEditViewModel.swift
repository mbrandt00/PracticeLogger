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
    func insertPiece(piece: Piece) async throws -> DbPiece {
        do {
            // Attempt to create the piece
            if let createdPiece = try await Database.createPiece(piece: piece) {
                return createdPiece
            } else {
                throw InsertionError.pieceCreationFailed
            }
        } catch {
            // Handle any other errors
            throw error
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
            if let response: MetadaInformation = try await Database.client.rpc("parse_opus_information", params: ["work_name": piece.workName]).execute().value {
                piece.opusNumber =  response.opus_number
                piece.opusType = response.opus_type
            }
            return piece
//            if let response: OpusInformation = try await Database.client.rpc("parse_piece_format", params: ["work_name": piece.workName]).execute().value {
//                print(response)
//                return piece
//            }
        } catch {
            print("Error getting piece information:", error)
            return nil
        }
        return nil
    }

    func isDuplicate(piece: Piece) async throws -> DbPiece? {
        do {
            guard let opusNumber = piece.opusNumber, let opusType = piece.opusType else {
                return nil
            }

            let currentUserID = try await String(Database.getCurrentUser().id.uuidString)

            // Attempt to decode the response
            let response: DbPiece = try await Database.client.rpc("find_duplicate_piece", params: ["opus_number": String(opusNumber), "opus_type": opusType.rawValue, "user_id": currentUserID, "composer_name": piece.composer.name ]).execute().value
            
            return response
        } catch {
            // Handle errors
            switch error {
            case let decodingError as DecodingError:
                // Check if the error is of type valueNotFound
                if case DecodingError.valueNotFound(_, _) = decodingError {
                    // Return nil if no value was found
                    return nil
                } else {
                    // Handle other decoding errors
                    print("Decoding error:", decodingError)
                    return nil
                }
            default:
                // Handle other types of errors
                print("Error in isDuplicate function:", error)
                return nil
            }
        }
    }
}

enum InsertionError: Error {
    case pieceCreationFailed
}

struct MetadaInformation: Decodable {
    var opus_type: OpusType
    var opus_number: Int
}

struct PieceFormat: Decodable {
    var opus_type: OpusType
    var opus_number: Int
}
