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

            let query = try Database.shared.client.from("pieces").insert([
                "work_name": piece.workName,
                "user_id": currentUserID.uuidString
            ])
            
            // Execute the insert query asynchronously
            let response = try await query.execute()
            print(response)
        } catch {
            // Handle any errors
            throw error
        }
    }
}
