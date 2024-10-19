//
//  SearchView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/5/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel

    var body: some View {
        Picker("Key Signature", selection: $searchViewModel.selectedKeySignature) {
            Text("Key Signature").tag(KeySignatureType?.none) // Default value
            ForEach(KeySignatureType.allCases) { keySignature in
                Text(keySignature.rawValue).tag(KeySignatureType?(keySignature))
            }
        }
        .pickerStyle(MenuPickerStyle())
        .onChange(of: searchViewModel.selectedKeySignature) {
            Task {
                await searchViewModel.searchPieces()
            }
        }

        List {
            if !searchViewModel.userPieces.isEmpty {
                Section(header: Text("Pieces")) {
                    ForEach(searchViewModel.userPieces) { piece in
                        NavigationLink(
                            value: PieceNavigationContext.userPiece(piece), label: {
                                RepertoireRow(piece: piece)
                            }
                        )
                    }
                }
            }
            if !searchViewModel.newPieces.isEmpty {
                Section(header: Text("New Pieces")) {
                    ForEach(searchViewModel.newPieces) { piece in
                        NavigationLink(
                            value: PieceNavigationContext.newPiece(piece), label: {
                                RepertoireRow(piece: piece)
                            }
                        )
                    }
                }
            }
        }
        .onChange(of: searchViewModel.searchTerm, initial: true) {
            Task {
                await searchViewModel.searchPieces()
            }
        }
    }
}

#Preview {
    SearchView(searchViewModel: SearchViewModel())
}
