//
//  NewPieceRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/10/24.
//

import SwiftUI

struct NewPieceRow: View {
    let piece: Piece

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading) {
                    Text(piece.workName)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                    Text(piece.composer.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    Tag("\(piece.movements.count) movements")
                }
            }
        }
        .padding(10)
    }
}

#Preview {
    NewPieceRow(piece: Piece(workName: "Sonata 2 in B flat Minor Funeral March An even longer impossibly long title blah blah", composer: Composer(name: "Frederic Chopin"), movements:
                                [
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Fuenbre", number: 3),
                                    Movement(name: "Finale", number: 4)
                                ], formattedKeySignature: "B♭ Minor")).previewLayout(.sizeThatFits)

}
