//
//  PieceShow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import SwiftUI

struct PieceShow: View {

    var piece: Piece
    @ObservedObject var viewModel = PracticeSessionViewModel()
    var body: some View {
        Text(piece.workName)
        Button(action: {
            Task {
                try await viewModel.startSession(record: .piece(piece))
            }
        }) {
            Image(systemName: "play.circle.fill")
        }
    }
}

#Preview {
    PieceShow(piece: Piece(workName: "Sonata 2 in B flat Minor Funeral March", composer: Composer(name: "Frederic Chopin"), movements: [
        Movement(name: "Grave - Doppio movimento", number: 1),
        Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
        Movement(name: "Marche Funebre", number: 3),
        Movement(name: "Finale", number: 4)
    ], formattedKeySignature: "Bb Minor", catalogue_type: CatalogueType.Op, catalogue_number: 35, nickname: "Funeral March", tonality: KeySignatureTonality.minor, key_signature: KeySignatureType.bFlat))
}