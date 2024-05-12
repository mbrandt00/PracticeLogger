//
//  PieceEdit.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/20/24.
//

import SwiftUI
import AlertToast
struct PieceEdit: View {
    var piece: Piece
    @ObservedObject var viewModel = PieceEditViewModel()
    @State private var showToast: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            Text(piece.workName)
                .font(.title)
            List {
                Section(header: Text("Movements").font(.headline).foregroundColor(.secondary)) {
                    ForEach(piece.movements.indices, id: \.self) { index in
                        var movement = piece.movements[index]
                        HStack {
                            Text(movement.number.toRomanNumeral() ?? "")
                                .font(.caption)
                                .frame(width: 24, height: 14)
                                .foregroundColor(.secondary)
                            TextField("", text: Binding(
                                get: {
                                    movement.name
                                },
                                set: { newValue, _ in // Ignore the transaction parameter
                                    if let index = piece.movements.firstIndex(where: { $0.id == movement.id }) {
                                        movement.name = newValue
                                    }
                                }
                            ))
                            .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                    
                }
                .listRowBackground(Color.clear)
                .padding(.vertical, 3)
            }
            .background(Color(UIColor.systemGroupedBackground))
        
                    Button(action: {
                        Task {
                            do {
                                let dbPiece = try await viewModel.insertPiece(piece: piece)
                                print(dbPiece)
                            } catch {
                                if let supabaseError = error as? SupabaseError {
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
            AlertToast(displayMode: .hud, type: .error(.red), title: errorMessage)
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
