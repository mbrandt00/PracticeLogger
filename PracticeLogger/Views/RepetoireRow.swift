//
//  RepetoireRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/28/24.
//

import ApolloGQL
import SwiftUI

struct RepertoireRow: View {
    var piece: PiecesQuery.Data.PiecesCollection.Edge.Node
    var body: some View {
        Text(piece.workName)
        if let composerName = piece.composer?.name {
            Text(composerName)
                .font(.caption)
        }
    }
}

// #Preview {
//    RepertoireRow(piece: Piece.examplePieces.randomElement()!)
// }
