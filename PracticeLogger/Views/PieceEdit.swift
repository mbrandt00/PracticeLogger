//
//  PieceEdit.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/20/24.
//

import SwiftUI
import AlertToast
struct PieceEdit: View {
    @State var piece: Piece
    @ObservedObject var viewModel: PieceEditViewModel
    @State private var showToast: Bool = false
    @State private var errorMessage: String = ""
    @State private var duplicatePiece: DbPiece?
    init(piece: Piece) {
        self._piece = State(initialValue: piece)
        self.viewModel = PieceEditViewModel(piece: piece)
    }
    var body: some View {

        VStack {
            if let duplicatePiece = duplicatePiece {
                // Render UI elements for the duplicate piece
                Text("Duplicate Piece Found:")
                    .font(.headline)
                Text("ID: \(duplicatePiece.id)")
                // Add more UI elements as needed
            }
            Text(piece.workName)
                .font(.title)

            List {
                ForEach(piece.movements.indices, id: \.self) { index in
                    MovementEditRow(
                        movement: piece.movements[index],
                        onUpdateMovementName: { newName in
                            viewModel.updateMovementName(at: index, newName: newName)
                        }
                    )

                }.onMove(perform: viewModel.move)
            }
            Button(action: {
                Task {
                    do {
                        let dbPiece = try await viewModel.insertPiece(piece: piece)
                        print(dbPiece)
                    } catch {
                        if let supabaseError = error as? SupabaseError {
                            print(supabaseError)
                            switch supabaseError {
                            case .pieceAlreadyExists:
                                errorMessage = "You have already added this piece"
                            }
                        } else {
                            errorMessage = "An unexpected error occurred."
                        }
                        showToast = true
                    }
                }
            }, label: {
                Text("Create")
            })
            .buttonStyle(.bordered)
            .foregroundColor(.black)
            .padding(3)
            Spacer()
        }
        .toast(isPresenting: $showToast) {
            AlertToast(type: .error(.red), title: errorMessage)
        }
        .onAppear {
            Task {
                do {
                    let piece = try await viewModel.addMetadata(to: piece)
                    if let piece = piece, let dbPiece = await viewModel.isDuplicate(piece: piece) {
                        duplicatePiece = dbPiece
                    }
                } catch {
                    print(error)
                }
            }
        }
    }
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
