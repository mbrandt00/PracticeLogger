//
//  SearchView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/5/24.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel
    @State private var selectedPieceContext: PieceNavigationContext? = nil

    var body: some View {
        VStack {
            Picker("Key Signature", selection: $searchViewModel.selectedKeySignature) {
                Text("Key Signature").tag(KeySignatureType?.none) // Default value
                ForEach(KeySignatureType.allCases) { keySignature in
                    Text(keySignature.rawValue).tag(KeySignatureType?(keySignature))
                }
            }
            .pickerStyle(MenuPickerStyle())

            List {
                // Display sections only if they have content
                if !searchViewModel.userPieces.isEmpty {
                    Section(header: Text("Pieces")) {
                        ForEach(searchViewModel.userPieces) { piece in
                            NavigationLink(
                                destination: PieceShow(piece: piece),
                                tag: PieceNavigationContext.userPiece(piece),
                                selection: $selectedPieceContext
                            ) {
                                RepertoireRow(piece: piece)
                            }
                        }
                    }
                }

                if !searchViewModel.newPieces.isEmpty {
                    Section(header: Text("New Pieces")) {
                        ForEach(searchViewModel.newPieces) { piece in
                            NavigationLink(
                                destination: PieceEdit(piece: piece),
                                tag: PieceNavigationContext.newPiece(piece),
                                selection: $selectedPieceContext
                            ) {
                                RepertoireRow(piece: piece)
                            }
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
    }
}

#Preview {
    SearchView(searchViewModel: SearchViewModel())
}
