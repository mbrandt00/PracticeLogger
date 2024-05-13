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
        for (index, _) in piece.movements.enumerated() {
            piece.movements[index].number = index + 1
        }
        self.piece = piece
    }
    
    func updateMovementName(at index: Int, newName: String) {
        guard index < piece.movements.count else { return } // Ensure index is within bounds
        piece.movements[index].name = newName

    }
}

enum InsertionError: Error {
    case pieceCreationFailed
}
