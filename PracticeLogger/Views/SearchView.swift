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
    @ObservedObject var practiceSessionViewModel: PracticeSessionViewModel
    @Binding var path: NavigationPath
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
                                    if let catalogueNumber = piece.catalogueNumber,
                                       let catalogueType = piece.catalogueType
                                    {
                                        Text(catalogueType.displayName + " " + String(catalogueNumber))
                                    }
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
                            PieceEdit(
                                piece: piece,
                                onPieceCreated: { @Sendable piece in
                                    path.append(PieceNavigationContext.userPiece(piece))
                                    await MainActor.run {
                                        searchViewModel.newPieces.removeAll()
                                        searchViewModel.searchTerm = ""
                                    }
                                }
                            )
                        }
                    }
                }
            }
        }
        .onChange(of: searchViewModel.searchTerm, initial: true) { _, _ in
            Task {
                await searchViewModel.searchPieces()
            }
        }
        .onAppear {
            Task {
                await searchViewModel.searchPieces()
            }
        }
    }

    struct RepertoireRow: View {
        var piece: PieceDetails
        var body: some View {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .center, spacing: 4) {
                        Text(piece.workName)
                            .font(.headline)
                            .lineLimit(1)

                        if piece.lastPracticed == nil {
                            NewItemBadge()
                        }
                    }

                    if let composerName = piece.composer?.name {
                        Text(composerName)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }

                Spacer()
            }
        }
    }

    struct NewItemBadge: View {
        var body: some View {
            // Custom layout to reduce spacing between icon and text
            HStack(spacing: 2) { // Reduced spacing between elements
                Image(systemName: "sparkles")
                    .font(.caption)

                Text("New")
                    .font(.caption)
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 4)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(8)
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
        viewModel.userPieces = PieceDetails.allPreviews

        return NavigationStack {
            StateWrapper(viewModel: viewModel)
        }
    }

    private struct StateWrapper: View {
        let viewModel: SearchViewModel
        @State private var path = NavigationPath()
        var body: some View {
            SearchView(searchViewModel: viewModel, practiceSessionViewModel: PracticeSessionViewModel(), path: $path)
        }
    }
}
