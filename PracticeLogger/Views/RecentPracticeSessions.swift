//
//  RecentPracticeSessions.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/13/24.
//

import ApolloGQL

import SwiftUI

struct RecentPracticeSessions: View {
    @ObservedObject var practiceSessionViewModel: PracticeSessionViewModel
    @State private var recentSessions = [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge]()
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var isSearching = false
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    @State private var isLoading = true
    @EnvironmentObject var uiState: UIState
    @State private var path = NavigationPath()

    var sessionSections: [SessionDaySection] {
        let grouped = Dictionary(grouping: recentSessions) { session in
            Calendar.current.startOfDay(for: session.node.startTime)
        }

        return grouped
            .map { key, value in
                SessionDaySection(id: key, date: key, sessions: value)
            }
            .sorted(by: { $0.date > $1.date }) // Keep latest day at the top
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                List {
                    if !isSearching {
                        if sessionSections.isEmpty && !isLoading {
                            VStack(spacing: 16) {
                                Image(systemName: "music.note.list")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 60, height: 60)
                                    .foregroundColor(.accentColor.opacity(0.7))

                                Text("No Practice Sessions")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.primary)

                                Text("Start practicing a piece to see your sessions here.")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.secondary)
                                    .padding(.horizontal)

                                Button {
                                    isSearching = true
                                } label: {
                                    Label("Start Practicing", systemImage: "play.circle.fill")
                                        .font(.headline)
                                        .padding()
                                        .frame(maxWidth: .infinity)
                                        .background(Color.accentColor)
                                        .foregroundColor(.white)
                                        .cornerRadius(12)
                                }
                                .padding(.horizontal, 32)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .padding()
                        } else {
                            ForEach(sessionSections) { section in
                                Section(header: Text(section.date.formatted(.dateTime.year().month().day()))) {
                                    ForEach(section.sessions, id: \.node.id) { session in
                                        NavigationLink(
                                            destination: PieceShow(
                                                piece: session.node.piece.fragments.pieceDetails,
                                                sessionManager: practiceSessionViewModel
                                            ),
                                            label: {
                                                RecentPracticeSessionListItem(
                                                    session: session.node,
                                                    onDelete: { id in
                                                        recentSessions.removeAll(where: { $0.node.id == id })
                                                    }
                                                )
                                            }
                                        )
                                    }
                                }
                            }
                        }
                    }
                    if isLoading {
                        ProgressView("Loading recent sessions…")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                }
                .animation(.default, value: sessionSections)
                .navigationTitle("Recent Sessions")
                .autocorrectionDisabled()
                .onAppear {
                    loadRecentSessions()
                }

                if isSearching {
                    VStack {
                        SearchView(searchViewModel: searchViewModel, path: $path)
                            .environmentObject(practiceSessionViewModel)
                            .background(Color.white)
                    }
                    .padding(.vertical, 2)
                }
            }
            .onChange(of: isSearching) { _, newValue in
                uiState.isScreenBusy = newValue
            }
            .onDisappear {
                if isSearching { // Only reset if we were searching when disappearing
                    uiState.isScreenBusy = false
                }
            }
            .navigationDestination(for: PieceNavigationContext.self) { context in
                switch context {
                case let .userPiece(piece):
                    pieceShowDestination(for: piece)

                case .newPiece:
                    EmptyView()
                }
            }
        }
        .searchable(text: $searchViewModel.searchTerm, isPresented: $isSearching, prompt: "Search pieces")
        .onSubmit(of: .search) {
            keyboardResponder.isKeyboardVisible = false
        }
    }

    @ViewBuilder
    private func pieceShowDestination(for piece: PieceDetails) -> some View {
        PieceShow(
            piece: piece,
            sessionManager: practiceSessionViewModel,
            onDelete: {
                Task { @MainActor in
                    searchViewModel.userPieces.removeAll(where: { $0.id == piece.id })
                    searchViewModel.searchTerm = ""
                    isSearching = false
                    await searchViewModel.searchPieces()
                }
            }
        )
    }

    private func loadRecentSessions() {
        Task {
            do {
                isLoading = true
                recentSessions = try await practiceSessionViewModel.getRecentUserPracticeSessions()
            } catch {
                print("Error fetching recent sessions: \(error)")
            }
            isLoading = false
        }
    }

    private func destination(for context: PieceNavigationContext) -> some View {
        switch context {
        case let .newPiece(piece):
            return AnyView(PieceEdit(piece: piece, isCreatingNewPiece: true))
        case let .userPiece(piece):
            return AnyView(PieceShow(piece: piece, sessionManager: practiceSessionViewModel))
        }
    }
}

struct SessionDaySection: Identifiable, Hashable {
    let id: Date
    let date: Date
    let sessions: [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge]
}
