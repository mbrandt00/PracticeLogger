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
        Text(piece.workName)
        if let composerName = piece.composer?.name {
            Text(composerName)
                .font(.caption)
        }
    }
}

#Preview {
    RepertoireRow(piece: Piece.examplePieces.randomElement()!)
}
