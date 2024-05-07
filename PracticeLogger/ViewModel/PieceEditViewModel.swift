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
            let dbPiece = try await Database.createPiece(piece: piece)
        } catch {
            // Handle any errors
            throw error
        }
    }
}
