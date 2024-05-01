//
//  PieceEditViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/28/24.
//

import Foundation
import Supabase
class PieceEditViewModel: ObservableObject {
    func insertPiece(piece: Piece) async throws {
        do {
            let currentUserID = try await Database.shared.getCurrentUser().id

            let dbPiece: DbPiece = try await Database.shared.client
                .from("pieces")
                .insert([
                    "work_name": piece.workName,
                    "user_id": currentUserID.uuidString
                ])
                .select()
                .single()
                .execute()
                .value

            let newPieceId = dbPiece.id
            print("newPieceId", newPieceId)

            for movement in piece.movements {
                print(movement)
                var dbMovement: DbPieceMovement = try await Database.shared.client
                    .from("movements")
                    .insert([
                        "movement_name": movement.name,
                        "movement_number": String(movement.number),
                        "piece_id": String(newPieceId)
                    ]).select().single().execute().value
            }

        } catch {
            // Handle any errors
            throw error
        }
    }
}

struct DbPiece: Codable {
  let id: Int
  let work_name: String
  let user_id: UUID
}

struct DbPieceMovement: Codable {
  let id: Int
  let movement_name: String
  let movement_number: Int
    let piece_id: Int
}
