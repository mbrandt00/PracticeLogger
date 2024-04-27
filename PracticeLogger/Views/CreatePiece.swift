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
    @State private var isLoading = false
    @FocusState private var searchIsFocused: Bool

    var body: some View {
        VStack {
            HStack {
                TextField("Enter a piece", text: $searchTerm, onEditingChanged: { editing in
                    isTyping = editing
                }, onCommit: {
                    Task {
                        await performSearch()
                    }
                })
                .padding(10)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .focused($searchIsFocused)

                Button(action: {
                    Task {
                        await performSearch()
                    }
                }) {
                    Text("Search")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundColor(.white)                         .cornerRadius(10)

                }
                .padding(.trailing, 10) // Add padding to the button
                .padding(.leading, 5) // Adjust the leading padding of the button
            }
            .padding(5)
            if isLoading {
                ProgressView()
                    .padding(4)
                    .background(Color.white)
                    .cornerRadius(6)
                    .offset(x: 0, y: -2)
            }
            
            
            NavigationStack {
                ScrollView {
                    LazyVStack {
                        ForEach(viewModel.pieces) { piece in
                            NavigationLink(value: piece) {
                                NewPieceRow(piece: piece)
                            }
                        }
                    }
                }
                .navigationDestination(for: Piece.self){ piece in
                    PieceEdit(piece: piece)
                }
                .navigationTitle(viewModel.pieces.isEmpty ? "" : "Piece Results")
            
            }
        }
    }

    func performSearch() async {
        isLoading = true
        await viewModel.getClassicalPieces(searchTerm)
        isLoading = false
        searchIsFocused = false
    }
}
 #Preview {
     CreatePiece(isTyping: .constant(false))
 }
