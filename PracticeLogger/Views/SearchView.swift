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
    @Binding var path: NavigationPath
    @State private var isShowingCustomPieceSheet = false
    @State private var isLoading: Bool
    private var preview: Bool = false

    init(
        searchViewModel: SearchViewModel,
        path: Binding<NavigationPath>,
        previewUserPieces: [PieceDetails]? = nil,
        previewNewPieces: [PieceDetails]? = nil
    ) {
        self.searchViewModel = searchViewModel
        _path = path
        _isLoading = State(initialValue: previewUserPieces == nil && previewNewPieces == nil)

        // Preload pieces for preview
        if let userPieces = previewUserPieces {
            self.searchViewModel.userPieces = userPieces
        }

        if let newPieces = previewNewPieces {
            self.searchViewModel.newPieces = newPieces
        }
    }

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
                    Section(
                        header:
                        HStack {
                            Text("Pieces")
                                .font(.headline)

                            Spacer()

                            if searchViewModel.searchTerm.isEmpty {
                                Button {
                                    isShowingCustomPieceSheet = true
                                } label: {
                                    Label("Custom Piece", systemImage: "plus.square")
                                        .font(.subheadline)
                                }
                                .accessibilityLabel("Create custom piece")
                            }
                        }
                        .padding(.top, 8)
                    ) {
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

                    Text("Try searching for a different piece or create a new piece.")
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    Button("Create custom piece", systemImage: "plus.square") {
                        isShowingCustomPieceSheet = true
                    }
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
        .sheet(isPresented: $isShowingCustomPieceSheet) {
            NavigationStack {
                PieceEdit(
                    piece: PieceDetails.empty,
                    isCreatingNewPiece: true,
                    onPieceCreated: handlePieceCreated
                )
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
                        Text("\(composer.firstName) \(composer.lastName)")
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

    private var formattedCatalogueInfo: String {
        if let type = piece.catalogueType?.displayName, let number = piece.catalogueNumber {
            return "\(type) \(number)"
        }
        return ""
    }

    private var totalTimeText: String {
        if let time = piece.totalPracticeTime, time > 0 {
            return time.formattedTimeDuration
        }
        return ""
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Line 1: Composer • Catalogue
            HStack(spacing: 4) {
                if isActive {
                    AnimatedQuarternotes()
                        .padding(.trailing, 4)
                }

                if let composer = piece.composer {
                    Text("\(composer.firstName ?? "") \(composer.lastName ?? "")")
                }

                if !formattedCatalogueInfo.isEmpty {
                    Text("•")
                    Text(formattedCatalogueInfo)
                }
            }
            .font(.footnote)
            .foregroundColor(.secondary)

            // Line 2: Work name + status indicators
            HStack(alignment: .center, spacing: 6) {
                Text(piece.workName)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                    .padding(.trailing, isActive ? 4 : 0)

                if piece.lastPracticed == nil {
                    NewItemBadge()
                }
            }

            // Line 3: Total practice time
            if !totalTimeText.isEmpty && totalTimeText != "0" {
                Text(totalTimeText)
                    .font(.footnote)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
}

enum PieceNavigationContext: Hashable {
    case userPiece(PieceDetails)
    case newPiece(PieceDetails)
}

struct RepertoireRow_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RepertoireRow(
                piece: PieceDetails.previewBach,
                isActive: false
            )
            .previewDisplayName("Practiced Piece")

            RepertoireRow(
                piece: PieceDetails.previewChopin,
                isActive: true
            )
            .previewDisplayName("New & Active Piece")
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
