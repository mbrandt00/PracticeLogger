//
//  RepetoireRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/28/24.
//

import SwiftUI

struct RepertoireRow: View {
    var piece: Piece
    var body: some View {
        NavigationLink(value: piece) {
            Text(piece.workName)
                .foregroundStyle(piece.savedPiece ? .red : .blue)
            if let composerName = piece.composer?.name {
                Text(composerName)
                    .font(.caption)
            }
        }
        .navigationDestination(for: Piece.self) { piece in
            if !piece.savedPiece {
                PieceEdit(piece: piece)
            } else {
                PieceShow(piece: piece)
            }
        }
        .padding()
    }
}

#Preview {
    RepertoireRow(piece: Piece.example)
}
