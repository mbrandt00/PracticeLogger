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
    @StateObject private var searchViewModel = SearchViewModel()
    @State private var isSearching = false
    @EnvironmentObject var keyboardResponder: KeyboardResponder
    @EnvironmentObject var uiState: UIState
    @State private var path = NavigationPath()
    private let previewSessions: [PracticeSessionDetails]?

    init(
        practiceSessionViewModel: PracticeSessionViewModel,
        previewSessions: [PracticeSessionDetails]? = nil
    ) {
        self.practiceSessionViewModel = practiceSessionViewModel
        self.previewSessions = previewSessions
    }

    var isLoading: Bool {
        practiceSessionViewModel.isLoading
    }

    var sessionSections: [SessionDaySection] {
        let grouped = Dictionary(grouping: practiceSessionViewModel.recentSessions) { session in
            Calendar.current.startOfDay(for: session.startTime)
        }

        return grouped
            .map { key, value in
                SessionDaySection(id: key, date: key, sessions: value)
            }
            .sorted(by: { $0.date > $1.date }) // Keep latest day at the top
    }

    private struct SessionListItemView: View {
        let session: PracticeSessionDetails
        let practiceSessionViewModel: PracticeSessionViewModel

        var body: some View {
            NavigationLink(
                destination: PieceShow(
                    piece: session.piece.fragments.pieceDetails,
                    sessionManager: practiceSessionViewModel
                )
            ) {
                RecentPracticeSessionListItem(session: session)
                    .swipeActions {
                        Button(role: .destructive) {
                            Task {
                                do {
                                    _ = try await Database.client
                                        .from("practice_sessions")
                                        .update(["deleted_at": Date()])
                                        .eq("id", value: session.id)
                                        .execute()

                                    if let index = practiceSessionViewModel.recentSessions.firstIndex(where: { $0.id == session.id }) {
                                        practiceSessionViewModel.recentSessions.remove(at: index)
                                    }

                                } catch let err {
                                    print(err)
                                }
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
            }
        }
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
                                    ForEach(section.sessions, id: \.id) { session in
                                        SessionListItemView(
                                            session: session,
                                            practiceSessionViewModel: practiceSessionViewModel
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
            sessionManager: practiceSessionViewModel
        )
    }

    private func loadRecentSessions() {
        Task {
            do {
                await practiceSessionViewModel.getRecentUserPracticeSessions()
            }
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
    let sessions: [PracticeSessionDetails]
}

// struct RecentPracticeSessions_Previews: PreviewProvider {
//    static var previews: some View {
//        RecentPracticeSessions(
//            practiceSessionViewModel: PracticeSessionViewModel(),
//            previewSessions: PracticeSessionDetails.allPreviews
//        )
//        .environmentObject(KeyboardResponder())
//        .environmentObject(UIState())
//    }
// }
