//
//  RecentPracticeSessions.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/13/24.
//

import SwiftUI

struct RecentPracticeSessions: View {
    @ObservedObject var practiceSessionViewModel: PracticeSessionViewModel
    @State private var recentSessions = [PracticeSession]()

    var body: some View {
        List {
            ForEach(recentSessions.groupedByDayAndPiece.keys.sorted(by: >), id: \.self) { day in
                Section(header: Text(day.formatted(.dateTime.year().month().day()))) {
                    ForEach(recentSessions.groupedByDayAndPiece[day]?.keys.sorted { $0.workName < $1.workName } ?? [], id: \.self) { piece in
                        let sessions = recentSessions.groupedByDayAndPiece[day]?[piece] ?? []
                        RecentPracticeSessionRow(piece: piece, sessions: sessions)
                    }
                }
            }
        }
        .listRowSeparatorTint(Color.accentColor, edges: .all)
        .listStyle(.plain)
        .navigationTitle("Recent Sessions")
        .onAppear {
            Task {
                recentSessions = try await practiceSessionViewModel.getRecentUserPracticeSessions()
            }
        }
    }
}

struct RecentPracticeSessions_Previews: PreviewProvider {
    static var previews: some View {
        RecentPracticeSessions(practiceSessionViewModel: MockPracticeSessionViewModel())
    }
}

class MockPracticeSessionViewModel: PracticeSessionViewModel {
    override func getRecentUserPracticeSessions() async throws -> [PracticeSession] {
        return PracticeSession.generateRandomSessions(count: 30)
    }
}
