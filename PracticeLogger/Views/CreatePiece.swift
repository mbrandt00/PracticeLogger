//
//  CreatePiece.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/28/24.
//

import SwiftUI
import MusicKit

struct CreatePiece: View {
    @ObservedObject var viewModel = CreatePieceViewModel()
    @Binding var isTyping: Bool
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            VStack {
                // Always show the search field
                TextField("Search", text: $viewModel.searchTerm)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)

                // Show loading indicator if needed
                if isLoading {
                    ProgressView()
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(6)
                        .offset(x: 0, y: -2)
                }

                // Conditionally display content based on searchTerm
                if viewModel.searchTerm.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Current Repertoire")
                            .font(.headline)
                            .padding([.leading, .top])

                        List(viewModel.userPieces) { piece in
                            Text(piece.workName)
                        }
                        .listStyle(PlainListStyle())
                    }
                    .navigationTitle("Recent Pieces")
                    .onAppear {
                        Task {
                            isLoading = true
                            do {
                                let pieces = try await viewModel.getUserPieces()
                                print(pieces)
                            } catch {
                                print("Error loading user pieces: \(error)")
                            }
                            isLoading = false
                        }
                    }
                } else {
                    VStack(alignment: .leading) {
                        Text("Search Results")
                            .font(.headline)
                            .padding([.leading, .top])

                        List(viewModel.pieces) { piece in
                            NavigationLink(destination: PieceEdit(piece: piece, isTyping: $isTyping)) {
                                NewPieceRow(piece: piece)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .navigationTitle("Search Pieces")
                    .task(id: viewModel.searchTerm) {
                        isLoading = true
                        await viewModel.getClassicalPieces(viewModel.searchTerm)
                        isLoading = false
                    }
                }
            }
            .navigationTitle("Search Pieces")
        }
    }
}

#Preview {
    CreatePiece(isTyping: .constant(false))
}
