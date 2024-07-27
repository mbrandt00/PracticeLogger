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
        NavigationStack {
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
                        .offset(y: -2)
                }

                if viewModel.searchTerm.isEmpty {
                    List(viewModel.userPieces) { piece in
                        RepertoireRow(piece: piece)
                    }
                    .listStyle(PlainListStyle())
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
                }
            }
            .onAppear {
                loadUserPieces()
            }
            .task(id: viewModel.searchTerm) {
                if !viewModel.searchTerm.isEmpty {
                    isLoading = true
                    await viewModel.getClassicalPieces(viewModel.searchTerm)
                    isLoading = false
                }
            }
        }
    }

    private func loadUserPieces() {
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
}

#Preview {
    CreatePiece()
}
