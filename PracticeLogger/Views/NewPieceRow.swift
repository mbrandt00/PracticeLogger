//
//  NewPieceRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/10/24.
//

import SwiftUI

struct NewPieceRow: View {
    let piece: Piece
    @State private var isExpanded: Bool = false
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {


            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(
                        //                        piece.formattedKeySignature != nil ? piece.workNameWithoutKeySignature() :  piece.workName
                        piece.workName


                    )
                    .font(.title3)
                    Text(piece.composer.name)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()

                // add instrument tag Orchestra/Concerto/Sonata etc
                if piece.formattedKeySignature != nil {
                    Text(piece.formattedKeySignature ?? "")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 5)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(6)


                }
            }

            DisclosureGroup(isExpanded: $isExpanded) {
            } label: {

                HStack {
                    Text("\(piece.movements.count) movements")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }


            }
        }
        .padding(10)

        if isExpanded {
            VStack(alignment: .leading, spacing: 10) {
                ForEach(piece.movements) { movement in
                    HStack {
                        Text(movement.number.toRomanNumeral() ?? "")
                            .font(.caption)
                            .frame(width: 24, height: 14)
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(6)


                        Text(movement.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading)

                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }

            }
            .padding(.horizontal, 10)
        }

    }
}







//#Preview {
//    NewPieceRow(piece: Piece(workName: "Sonata 2 in B flat Minor Funeral March", composer: Composer(name: "Frederic Chopin"), movements:
//                                [
//                                    Movement(name: "Grave - Doppio movimento", number: 1),
//                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
//                                    Movement(name: "Marche Fuenbre", number: 3),
//                                    Movement(name: "Finale", number: 4)
//                                ], formattedKeySignature: "B♭ Minor")).previewLayout(.sizeThatFits)
//
//}
