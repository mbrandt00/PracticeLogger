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
    var body: some View {
        VStack {
            TextField("Search for music", text: $searchTerm)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                Task {
                    await viewModel.getClassicalPieces(searchTerm)

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

 #Preview {
    CreatePiece()
 }
