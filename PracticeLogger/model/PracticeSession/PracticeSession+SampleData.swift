//
//  PracticeSession+SampleData.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/13/24.
//

import Foundation

extension PracticeSession {
    static func generateRandomSessions(count: Int) -> [PracticeSession] {
        var sessions: [PracticeSession] = []

        for _ in 0 ..< count {
            let piece = Piece.examplePieces.randomElement()!
            let startTime = randomDateInLastWeek()
            let endTime = Calendar.current.date(byAdding: .hour, value: 2, to: startTime)!

            let session = PracticeSession(
                startTime: startTime,
                endTime: endTime, piece: piece,
                durationSeconds: 720,
                movement: piece.randomMovement() // Two hours in seconds
            )
            sessions.append(session)
        }

        return sessions
    }
}

func randomDateInLastWeek() -> Date {
    let calendar = Calendar.current
    let today = Date()
    let oneWeekAgo = calendar.date(byAdding: .weekOfYear, value: -1, to: today)!
    let randomInterval = TimeInterval(arc4random_uniform(UInt32(today.timeIntervalSince(oneWeekAgo))))
    return calendar.date(byAdding: .second, value: Int(randomInterval), to: oneWeekAgo)!
}
