//
//  RepetoireRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/28/24.
//

import SwiftUI

struct RecentPracticeSessionRow: View {
    var piece: Piece
    var sessions: [PracticeSession]
    @State var isExpanded: Bool = false

    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(alignment: .leading, spacing: 5) {
                    let sortedSessions = sessions.sorted { $0.endTime! < $1.endTime! }
                    ForEach(sortedSessions) { session in
                        VStack(alignment: .leading, spacing: 4) {
                            if let movement = session.movement {
                                Text(movement.name)
                                    .font(.body)
                                    .fontWeight(.medium)
                            }

                            Text(session.startTime.formatted(
                                .dateTime
                                    .hour().minute()
                            ))
                            .font(.subheadline)
                            .fontWeight(.regular)

                            Text(session.durationSeconds?.formattedTimeDuration ?? "")
                                .font(.subheadline)
                                .fontWeight(.regular)
                        }
                        .padding(.vertical, 2)
                        .padding(.leading, 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            },
            label: {
                VStack(alignment: .leading, spacing: 2) {
                    Text(piece.workName)
                        .font(.title3)
                        .fontWeight(.bold)
                        .lineLimit(1)

                    if let composerName = piece.composer?.name {
                        Text(composerName)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                    }
                }
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
        .padding()
    }
}

struct RecentPracticeSessionRow_Previews: PreviewProvider {
    static var piece: Piece =
        .example1

    static var sessions: [PracticeSession] =
        [
            PracticeSession(
                startTime: Date(),
                endTime: Calendar.current.date(byAdding: .hour, value: 2, to: Date()),
                piece: piece,
                durationSeconds: 1200,
                movement: piece.movements.first
            ),
            PracticeSession(
                startTime: Calendar.current.date(byAdding: .hour, value: -3, to: Date()) ?? Date.now,
                endTime: Calendar.current.date(byAdding: .hour, value: -1, to: Date()),
                piece: piece,
                durationSeconds: 1800,
                movement: piece.movements.last
            )
        ]

    static var previews: some View {
        VStack {
            RecentPracticeSessionRow(piece: piece, sessions: sessions, isExpanded: true)
            RecentPracticeSessionRow(piece: piece, sessions: sessions)
        }
    }
}
