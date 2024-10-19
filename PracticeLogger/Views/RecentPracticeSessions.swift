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

    var groupedSessionsByDay: [Date: [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge]] {
        Dictionary(grouping: recentSessions) { session in
            Calendar.current.startOfDay(for: session.node.startTime)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                List {
                    if !isSearching {
                        let sortedDays = groupedSessionsByDay.keys.sorted(by: >)

                        ForEach(sortedDays, id: \.self) { day in
                            Section(header: Text(day.formatted(.dateTime.year().month().day()))) {
                                let daySessions = groupedSessionsByDay[day] ?? []

                                ForEach(daySessions, id: \.node.id) { session in
                                    NavigationLink(destination: PracticeSessionView(session: session)) {
                                        VStack(alignment: .leading) {
                                            if let movement = session.node.movement {
                                                if let name = movement.name {
                                                    Text(name)
                                                        .font(.body)
                                                        .fontWeight(.medium)
                                                }
                                            }

                                            Text(session.node.startTime.formatted(
                                                .dateTime.hour().minute()
                                            ))
                                            .font(.subheadline)
                                            .fontWeight(.regular)

                                            Text(session.node.durationSeconds?.formattedTimeDuration ?? "")
                                                .font(.subheadline)
                                                .fontWeight(.regular)
                                        }
                                        .padding(.vertical, 2)
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("Recent Sessions")
                .autocorrectionDisabled()
                .onAppear {
                    Task {
                        do {
                            recentSessions = try await practiceSessionViewModel.getRecentUserPracticeSessions()
                        } catch {
                            print("Error fetching recent sessions: \(error)")
                        }
                    }
                }

                if isSearching {
                    VStack {
                        SearchView(searchViewModel: searchViewModel)
                            .background(Color.white) // Add a background to distinguish the view
                    }
                }
            }
        }
        .searchable(text: $searchViewModel.searchTerm, isPresented: $isSearching)
    }
}
