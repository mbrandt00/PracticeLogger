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
                if isLoading {
                    ProgressView()
                        .padding(4)
                        .background(Color.white)
                        .cornerRadius(6)
                        .offset(x: 0, y: -2)
                }

                List(viewModel.pieces) { piece in
                    NavigationLink(destination: PieceEdit(piece: piece, isTyping: $isTyping)) {
                        NewPieceRow(piece: piece)

                    }
                }
                .listStyle(PlainListStyle())
                .searchable(text: $viewModel.searchTerm)
                .autocorrectionDisabled(true)
                .onChange(of: viewModel.searchTerm) {
                    Task {
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
