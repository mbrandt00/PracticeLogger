//
//  CreatePiece.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/28/24.
//

import MusicKit
import SwiftUI

struct CreatePiece: View {
    @StateObject var viewModel = CreatePieceViewModel()
    @State private var isLoading = false
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search", text: $viewModel.searchTerm)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocorrectionDisabled(true)
                if isLoading {
                    ProgressView()
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(6)
                        .offset(x: 0, y: -2)
                }

                if viewModel.searchTerm.isEmpty {
                    VStack(alignment: .leading) {
                        Text("Repetoire")
                            .font(.headline)
                            .padding([.leading, .top])

                        List(viewModel.userPieces) { piece in
                            RepertoireRow(piece: piece)
                        }
                        .listStyle(PlainListStyle())
                    }
                    .navigationTitle("Recent Pieces")
                    .onAppear {
                        Task {
                            isLoading = true
                            do {
                                _ = try await viewModel.getUserPieces()
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
                            NavigationLink(destination: PieceEdit(piece: piece)) {
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
    CreatePiece()
}
