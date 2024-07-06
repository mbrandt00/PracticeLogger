//
//  RepetoireRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/28/24.
//

import SwiftUI

struct RepertoireRow: View {
    var piece: Piece
    @Binding var isTyping: Bool
    var body: some View {
        NavigationLink(destination: PieceShow(piece: piece)) {
            Text(piece.workName)
        }
        .padding()
    }

}

#Preview {
    RepertoireRow(piece: Piece(workName: "Sonata 2 in B flat Minor Funeral March", composer: Composer(name: "Frederic Chopin"), movements: [
        Movement(name: "Grave - Doppio movimento", number: 1),
        Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
        Movement(name: "Marche Funebre", number: 3),
        Movement(name: "Finale", number: 4)
    ], formattedKeySignature: "Bb Minor", catalogue_type: CatalogueType.Op, catalogue_number: 35, nickname: "Funeral March", tonality: KeySignatureTonality.minor, key_signature: KeySignatureType.bFlat), isTyping: .constant(false))
}
