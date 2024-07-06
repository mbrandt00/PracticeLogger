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
//    @EnvironmentObject private var psm: PracticeSessionManager
    var body: some View {
//        VStack {
//            Text("Active Session Piece ID: \(psm.activeSession?.piece?.workName)")
//        };
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
                        Text("Repetoire")
                            .font(.headline)
                            .padding([.leading, .top])

                        List(viewModel.userPieces) { piece in
                            RepertoireRow(piece: piece, isTyping: $isTyping)
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
