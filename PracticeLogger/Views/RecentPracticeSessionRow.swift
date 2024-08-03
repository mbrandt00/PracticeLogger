//
//  RepetoireRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/28/24.
//

import SwiftUI

struct RecentPracticeSessionRow: View {
    var practiceSession: PracticeSession
    var body: some View {
        NavigationLink(value: practiceSession) {
            VStack(alignment: .leading) {
                if let workName = practiceSession.piece?.workName {
                    Text(workName)
                }

                Text(practiceSession.durationSeconds?.formattedTimeDuration ?? "")
                if let composerName = practiceSession.piece?.composer?.name {
                    Text(composerName)
                        .font(.caption)
                }
            }
        }
        .navigationDestination(for: PracticeSession.self) { ps in
            PieceShow(piece: ps.piece!)
        }
        .padding()
    }
}

struct RecentPracticeSessionRow_Previews: PreviewProvider {
    static var session: PracticeSession = {
        var exampleSession = PracticeSession.endedExample
        exampleSession.durationSeconds = 12000
        return exampleSession
    }()

    static var previews: some View {
        // Create and return the view for preview
        RecentPracticeSessionRow(practiceSession: session)
    }
}
