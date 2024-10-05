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

    var groupedSessionsByDay: [Date: [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge]] {
        Dictionary(grouping: recentSessions) { session in
            Calendar.current.startOfDay(for: session.node.startTime)
        }
    }

    var body: some View {
        List {
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
            .listRowSeparatorTint(Color.accentColor, edges: .all)
        }
        .listStyle(.plain)
        .navigationTitle("Recent Sessions")
        .onAppear {
            Task {
                do {
                    recentSessions = try await practiceSessionViewModel.getRecentUserPracticeSessions()
                } catch {
                    print("Error fetching recent sessions: \(error)")
                }
            }
        }
    }
}
