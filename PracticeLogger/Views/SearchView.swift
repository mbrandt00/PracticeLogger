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
    @EnvironmentObject var practiceSessionViewModel: PracticeSessionViewModel
    @State var isLoading: Bool = true
    @Binding var path: NavigationPath

    private var isEmpty: Bool {
        searchViewModel.userPieces.isEmpty && searchViewModel.newPieces.isEmpty
    }

    private var shouldShowSpinner: Bool {
        isLoading && isEmpty
    }

    private var shouldShowEmptyState: Bool {
        !isLoading && isEmpty
    }

    var body: some View {
        ZStack {
            List {
                if !searchViewModel.userPieces.isEmpty {
                    Section(header: Text("Pieces")) {
                        ForEach(searchViewModel.userPieces, id: \.id) { piece in
                            userPieceRow(piece)
                        }
                    }
                }

                if !searchViewModel.newPieces.isEmpty {
                    Section(header: Text("New Pieces")) {
                        ForEach(searchViewModel.newPieces, id: \.id) { piece in
                            newPieceRow(piece)
                        }
                    }
                }
            }
            if shouldShowSpinner {
                ProgressView("Searching...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            if shouldShowEmptyState {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundColor(.accentColor.opacity(0.6))

                    Text("No results found")
                        .font(.title3)
                        .fontWeight(.semibold)

                    Text("Try searching for a different piece, or check back later.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            }
        }
        .onAppear {
            Task {
                isLoading = true
                await searchViewModel.searchPieces()
                isLoading = false
            }
        }
        .onChange(of: searchViewModel.searchTerm) { _, _ in
            // Only show loading if we don't already have results
            if searchViewModel.userPieces.isEmpty && searchViewModel.newPieces.isEmpty {
                isLoading = true
            }

            Task {
                await searchViewModel.searchPieces()
                isLoading = false
            }
        }
        .sheet(item: $searchViewModel.selectedPiece) { piece in
            NavigationStack {
                PieceEdit(piece: piece, isCreatingNewPiece: true, onPieceCreated: handlePieceCreated)
            }
        }
    }

    private func userPieceRow(_ piece: PieceDetails) -> some View {
        NavigationLink(value: PieceNavigationContext.userPiece(piece)) {
            RepertoireRow(
                piece: piece,
                isActive: practiceSessionViewModel.activeSession?.piece.id == piece.id
            )
        }
    }

    private func newPieceRow(_ piece: PieceDetails) -> some View {
        Button {
            searchViewModel.selectedPiece = piece
        } label: {
            HStack {
                VStack(alignment: .leading) {
                    Text(piece.workName).font(.headline)

                    let catalogueNumber = piece.catalogueNumber
                    let catalogueType = piece.catalogueType

                    if let catalogueNumber, let catalogueType {
                        Text("\(catalogueType.displayName) \(catalogueNumber)")
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
        }
    }

    private func handlePieceCreated(_ piece: PieceDetails) async {
        path.append(PieceNavigationContext.userPiece(piece))
        await MainActor.run {
            searchViewModel.newPieces.removeAll()
            searchViewModel.searchTerm = ""
        }
    }
}

struct RepertoireRow: View {
    var piece: PieceDetails
    var isActive: Bool = false

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 6) {
                    Text(piece.workName)
                        .font(.headline)
                        .lineLimit(1)

                    if isActive {
                        Image(systemName: "music.quarternote.3")
                            .foregroundStyle(Color.theme.accent.opacity(0.6))
                    }

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
        HStack(spacing: 2) {
            Image(systemName: "sparkles").font(.caption)
            Text("New").font(.caption)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(8)
    }
}

enum PieceNavigationContext: Hashable {
    case userPiece(PieceDetails)
    case newPiece(PieceDetails)
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        let searchViewModel = SearchViewModel()
        searchViewModel.newPieces = []
        searchViewModel.userPieces = PieceDetails.allPreviews

        let practiceSessionViewModel = PracticeSessionViewModel()

        return NavigationStack {
            StateWrapper(
                searchViewModel: searchViewModel,
                practiceSessionViewModel: practiceSessionViewModel
            )
        }
    }

    private struct StateWrapper: View {
        let searchViewModel: SearchViewModel
        let practiceSessionViewModel: PracticeSessionViewModel
        @State private var path = NavigationPath()

        var body: some View {
            SearchView(searchViewModel: searchViewModel, path: $path)
                .environmentObject(practiceSessionViewModel)
        }
    }
}
