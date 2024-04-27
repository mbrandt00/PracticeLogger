//
//  PieceEdit.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/20/24.
//

import SwiftUI

struct PieceEdit: View {
    let piece: Piece
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(piece.workName)
                .font(.title)
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
            Button(action: {
                Task {
                    await piece.submitPiece()
                }
            }){
                Text("Create")
            }.buttonStyle(.bordered)
                .foregroundColor(.black)
                .padding(3)

        }
        
        .padding(.horizontal, 10)    }
    
}

#Preview {
    PieceEdit(piece: Piece(workName: "Sonata 2 in B flat Minor Funeral March", composer: Composer(name: "Frederic Chopin"), movements:
                                    [
                                        Movement(name: "Grave - Doppio movimento", number: 1),
                                        Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                        Movement(name: "Marche Fuenbre", number: 3),
                                        Movement(name: "Finale", number: 4)
                                    ], formattedKeySignature: "B♭ Minor"))
}
