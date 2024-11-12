//
//  NewPieceRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/10/24.
//

import SwiftUI

struct NewPieceRow: View {
    @State var piece: Piece

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading) {
                    Text(piece.workName)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                    Text(piece.composer?.name ?? "No Composer")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    Tag("\(piece.movements.count) movements")
                    if let keySignature = piece.key_signature, let tonality = piece.tonality {
                        Tag("\(keySignature.rawValue) \(tonality.rawValue)")
                    }
                }
            }
        }
        .padding(10)
    }
}

//
// struct NewPieceRow_Previews: PreviewProvider {
//    static var previews: some View {
//        let piece = Piece.examplePieces.randomElement()!
//
//        return NewPieceRow(piece: piece)
//            .previewLayout(.sizeThatFits)
//    }
// }
