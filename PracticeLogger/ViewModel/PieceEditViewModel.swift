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
    func insertPiece(piece: Piece) async throws -> Piece? {
        do {
            let composer: Composer = try await Database.client
                .rpc("find_or_create_composer", params: ["name": piece.composer.name])
                .execute()
                .value

            piece.composer.id = composer.id

            let insertedPiece: Piece = try await Database.client.from("pieces")
                .insert(piece)
                .select()
                .single()
                .execute()
                .value

            let newPieceId = insertedPiece.id
            piece.movements.forEach { $0.pieceId = newPieceId }
            try await Database.client
                .from("movements")
                .insert(piece.movements)
                .execute()

            return insertedPiece

        } catch let error as PostgrestError {
            print("INSERT ERROR", error)

            if error.message.contains("pieces_catalogue_unique") {
                throw SupabaseError.pieceAlreadyExists
            }
            return nil
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

                piece.catalogue_number =  response.catalogue_number
                piece.catalogue_type = response.catalogue_type
                piece.key_signature = response.key_signature
                piece.tonality = response.tonality
                piece.format = response.format
                piece.nickname = response.nickname
            }

            return piece
        } catch {
            print("Error getting piece information:", error)
            return nil
        }
    }

    func isDuplicate(piece: Piece) async throws -> Piece? {
        do {
            guard let catalogue_number = piece.catalogue_number, let catalogue_type = piece.catalogue_type else {
                return nil
            }

            let currentUserID = try await String(Database.getCurrentUser().id.uuidString)

            let response: Piece = try await Database.client.rpc("find_duplicate_piece", params: ["catalogue_number": String(catalogue_number), "catalogue_type": catalogue_type.rawValue, "user_id": currentUserID, "composer_name": piece.composer.name ]).execute().value

            return response
        } catch {
            // Handle errors
            switch error {
            case let decodingError as DecodingError:
                // Check if the error is of type valueNotFound
                if case DecodingError.valueNotFound(_, _) = decodingError {
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
