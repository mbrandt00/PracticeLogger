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
//    var onUpdateMovementName: (Int, String) -> Void
    init(piece: Piece) {
        self._piece = State(initialValue: piece)
        self.viewModel = PieceEditViewModel(piece: piece)
    }
    var body: some View {
        VStack {
            Text(piece.workName)
                .font(.title)
//            NavigationStack {
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

//            }
                Button(action: {
                    Task {
                        do {
                            let dbPiece = try await viewModel.insertPiece(piece: piece)
                        } catch {
                            if let supabaseError = error as? SupabaseError {
                                print(supabaseError)
                                switch supabaseError {
                                case .pieceAlreadyExists:
                                    errorMessage = "You have already added this piece"
                                    // Add more cases as needed
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

        }
    private func move(from source: IndexSet, to destination: Int) {
        piece.movements.move(fromOffsets: source, toOffset: destination)
        var newMovements: [Movement] = []
        for (index, movement) in piece.movements.enumerated() {
            var movement = movement
            movement.number = index + 1
            newMovements.append(movement)
        }
        piece.movements = newMovements
        print(piece.movements.map {($0.name, $0.number)})
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
