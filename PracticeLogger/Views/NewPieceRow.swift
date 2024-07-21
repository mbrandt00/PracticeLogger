//
//  NewPieceRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/10/24.
//

import SwiftUI

struct NewPieceRow: View {
    @StateObject private var viewModel: NewPieceRowViewModel
    @State var piece: Piece

    init(piece: Piece) {
        _viewModel = StateObject(wrappedValue: NewPieceRowViewModel(piece: piece))
        self.piece = piece
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading) {
                    Text(viewModel.piece.workName)
                        .font(.title3)
                        .multilineTextAlignment(.leading)
                    Text(viewModel.piece.composer?.name ?? "No Composer")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 10) {
                    Tag("\(viewModel.piece.movements.count) movements")
                    if let keySignature = viewModel.piece.key_signature, let tonality = viewModel.piece.tonality {
                        Tag("\(keySignature.rawValue) \(tonality.rawValue)")
                    }
                }
            }
        }
        .onAppear {
            Task {
                do {
                    let updatedPiece = try await viewModel.addMetadata(to: piece)
                    if let updatedPiece = updatedPiece {
                        DispatchQueue.main.async {
                            self.piece = updatedPiece
                        }
                    }
                } catch {
                    print(error)
                }
            }
        }
        .padding(10)
    }
}

struct NewPieceRow_Previews: PreviewProvider {
    static var previews: some View {
        let piece = Piece.example

        let viewModel = NewPieceRowViewModel(piece: piece)

        return NewPieceRow(piece: piece)
            .environmentObject(viewModel)
            .previewLayout(.sizeThatFits)
    }
}
