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
    @State private var recentSessions: [PracticeSession] = []
    @State private var userPieces: [Piece] = []
    var body: some View {
        NavigationStack {
            VStack {
                if isLoading {
                    ProgressView()
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(6)
                        .offset(y: -2)
                }

                if viewModel.searchTerm.isEmpty {
                    if recentSessions.isEmpty {
                        if userPieces.isEmpty {
                            HStack(alignment: .center) {
                                Text("Add a piece by searching to start practicing!")
                            }
                        } else {
                            List(userPieces) { piece in
                                RepertoireRow(piece: piece)
                            }
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
                    .padding()
                }
            }
            .onAppear {
                Task {
                    do {
                        recentSessions = try await viewModel.getRecentUserPracticeSessions()
                        if recentSessions.isEmpty {
                            userPieces = try await viewModel.getUserPieces()
                        }
                    } catch {
                        print("Error loading recent user practice sessions \(error.localizedDescription)")
                    }
                }
            }
            .task(id: viewModel.searchTerm) {
                if !viewModel.searchTerm.isEmpty {
                    isLoading = true
//                    await viewModel.getClassicalPieces(viewModel.searchTerm)
                    isLoading = false
                }
            }
        }
    }
}

#Preview {
    CreatePiece()
}
