//
//  CreatePiece.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/28/24.
//

import SwiftUI
import MusicKit
struct CreatePiece: View {
    @State private var searchTerm = ""
    @ObservedObject var viewModel = CreatePieceViewModel()
    @Binding var isTyping: Bool
    @FocusState private var searchIsFocused: Bool
    var body: some View {
        VStack {
            TextField("Search for music", text: $searchTerm, onEditingChanged: { editing in
                isTyping = editing
            })
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .focused($searchIsFocused)

            Button(action: {
                Task {
                    await viewModel.getClassicalPieces(searchTerm)
                    searchIsFocused = false

                }
            }) {
                Text("Search")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            ScrollView {
                ForEach(viewModel.pieces) { piece in
                    NewPieceRow(piece: piece)
                }
            }
        }
    }
}

// #Preview {
//    CreatePiece()
// }
