//
//  SearchView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/5/24.
//

import ApolloGQL
import SwiftUI

struct SearchView: View {
    @ObservedObject var searchViewModel: SearchViewModel

    var body: some View {
        List {
            if !searchViewModel.userPieces.isEmpty {
                Section(header: Text("Pieces")) {
                    ForEach(searchViewModel.userPieces, id: \.id) { piece in
                        NavigationLink(
                            value: PieceNavigationContext.userPiece(piece),
                            label: {
                                RepertoireRow(piece: piece)
                            }
                        )
                    }
                }
            }
            if !searchViewModel.newPieces.isEmpty {
                Section(header: Text("New Pieces")) {
                    ForEach(searchViewModel.newPieces, id: \.id) { piece in
                        Button(action: {
                            searchViewModel.selectedPiece = piece
                        }, label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(piece.workName)
                                        .font(.headline)
                                    if let composer = piece.composer {
                                        Text(composer.name)
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                    }
                                }

                                Spacer()

                                Image(systemName: "plus.rectangle")
                                    .foregroundColor(.gray)
                            }
                            .contentShape(Rectangle())
                        })
                    }
                    .sheet(item: $searchViewModel.selectedPiece) { piece in
                        NavigationStack {
                            PieceEdit(piece: piece)
                        }
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

enum PieceNavigationContext: Hashable {
    case userPiece(PieceDetails)
    case newPiece(ImslpPieceDetails)
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = SearchViewModel()
        viewModel.newPieces = ImslpPieceDetails.samplePieces

        return NavigationStack {
            SearchView(searchViewModel: viewModel)
        }
    }
}
