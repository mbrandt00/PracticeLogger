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
        HStack {
            VStack(alignment: .leading) {
                Text(piece.workName)
                    .font(.title3)
                // movements
//                GeometryReader { geometry in
                    HStack {
                        ForEach(piece.movements) {movement in
                            Text(movement.name)
                                .font(.caption)
                                .lineLimit(3)
                                .truncationMode(.tail)
//                                ./*frame(width: geometry.size.width * (1 / CGFloat(piece.movements.count + 1)) )*/
                        }
                    }

//                }.frame(maxHeight: 28)
            }
            Spacer()
            Text(piece.composer.name)

        }.padding()
    }

}

#Preview {
    NewPieceRow(piece: Piece(workName: "Chopin Sonata 2", composer: Composer(name: "Frederic Chopin"), movements:
                                [
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Fuenbre", number: 3),
                                    Movement(name: "Finale", number: 3)
                                ])).previewLayout(.sizeThatFits)

}
