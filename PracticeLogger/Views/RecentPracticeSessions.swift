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
    @EnvironmentObject var uiState: UIState
    @State private var path = NavigationPath()

    var groupedSessionsByDay: [Date: [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge]] {
        Dictionary(grouping: recentSessions) { session in
            Calendar.current.startOfDay(for: session.node.startTime)
        }
    }

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                List {
                    if !isSearching {
                        let sortedDays = groupedSessionsByDay.keys.sorted(by: >)

                        ForEach(sortedDays, id: \.self) { day in
                            Section(header: Text(day.formatted(.dateTime.year().month().day()))) {
                                let daySessions = groupedSessionsByDay[day] ?? []

                                ForEach(daySessions, id: \.node.id) { session in
                                    let piece = session
                                    NavigationLink(destination: PieceShow(piece: session.node.piece.fragments.pieceDetails, sessionManager: practiceSessionViewModel)) {
                                        sessionRow(session: session)
                                    }
                                }
                            }
                        }
                    }
                }
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
                case .userPiece(let piece):
                    PieceShow(piece: piece, sessionManager: practiceSessionViewModel)
                case .newPiece(let piece):
                    // Handle navigation for new pieces if needed
                    EmptyView()
                }
            }
        }
        .searchable(text: $searchViewModel.searchTerm, isPresented: $isSearching, prompt: "Search pieces")
        .onSubmit(of: .search) {
            keyboardResponder.isKeyboardVisible = false
        }
    }

    private func sessionRow(session: RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge) -> some View {
        VStack(alignment: .leading) {
            Text(session.node.piece.workName)
                .font(.title3)
            if let movement = session.node.movement, let name = movement.name {
                Text(name)
                    .font(.body)
                    .fontWeight(.medium)
            }

            Text(session.node.startTime.formatted(.dateTime.hour().minute()))
                .font(.subheadline)
                .fontWeight(.regular)

            Text(session.node.durationSeconds?.formattedTimeDuration ?? "")
                .font(.subheadline)
                .fontWeight(.regular)
        }
        .padding(.vertical, 2)
        .swipeActions {
            Button(role: .destructive) {
                Task {
                    do {
                        let result = try await Database.client.from("practice_sessions")
                            .delete()
                            .eq("id", value: session.node.id)
                            .execute()

                        print(result)
                    } catch (let err) {
                        print(err)
                        // Handle errors here
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }

    private func loadRecentSessions() {
        Task {
            do {
                recentSessions = try await practiceSessionViewModel.getRecentUserPracticeSessions()
            } catch {
                print("Error fetching recent sessions: \(error)")
            }
        }
    }

    private func destination(for context: PieceNavigationContext) -> some View {
        switch context {
        case .newPiece(let piece):
            return AnyView(PieceEdit(piece: piece, isCreatingNewPiece: true))
        case .userPiece(let piece):
            return AnyView(PieceShow(piece: piece, sessionManager: practiceSessionViewModel))
        }
    }
}
