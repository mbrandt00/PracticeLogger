//
//  PieceEdit.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/20/24.
//

import SwiftUI
import AlertToast
struct PieceEdit: View {
    let piece: Piece
    @ObservedObject var viewModel = PieceEditViewModel()
    @State private var showToast: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 10) {
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
        }
        .padding(.horizontal, 10)
                // Your existing code for displaying piece details
            }
            .padding(.horizontal, 10)
            VStack {
                Button(action: {
                    Task {
                        do {
                            try await viewModel.insertPiece(piece: piece)
                        } catch {
                            // Handle the error and show the error message in a toast
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
            }
        }
        // Show the alert toast when showErrorToast is true
        .toast(isPresenting: $showToast){

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
