//
//  PracticeSessionView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 10/5/24.
//
import ApolloGQL
import SwiftUI

struct PracticeSessionView: View {
    var session: PracticeSessionDetails

    private var formattedDuration: String {
        if let seconds = session.durationSeconds {
            let minutes = seconds / 60
            return "\(minutes) min"
        } else if session.endTime == nil {
            return "In Progress"
        } else {
            return "Unknown"
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top, spacing: 16) {
                // Status indicator and time
                VStack(alignment: .center, spacing: 4) {
                    Circle()
                        .fill(session.endTime == nil ? Color.green : Color.secondary)
                        .frame(width: 8, height: 8)

                    Text(formattedDuration)
                        .font(.callout)
                        .foregroundStyle(session.endTime == nil ? .green : .secondary)
                        .frame(width: 80)
                }

                // Piece and movement info
                VStack(alignment: .leading, spacing: 6) {
                    Text(session.piece.workName)
                        .font(.headline)
                        .lineLimit(2)

                    if let composer = session.piece.composer?.name {
                        Text(composer)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    if let movement = session.movement?.name {
                        Text(movement)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }

                    // Time details
                    HStack(spacing: 8) {
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                                .font(.caption)
                            Text(session.startTime.formatted(date: .omitted, time: .shortened))
                        }

                        if let endTime = session.endTime {
                            Text("→")
                            Text(endTime.formatted(date: .omitted, time: .shortened))
                        }
                    }
                    .font(.caption)
                    .foregroundStyle(.secondary)
                }

                Spacer()
            }
            .padding()

            Divider()
        }
        .background(Color(uiColor: .systemBackground))
        .contentShape(Rectangle())
    }
}

// Preview with mock data
// #Preview {
//    VStack {
//        // Completed session with movement
//        PracticeSessionView(session: .init(
//            node: .init(
//                id: BigInt(1),
//                startTime: Date().addingTimeInterval(-3600),
//                durationSeconds: 3600,
//                piece: .init(
//                    imslpPieceId: BigInt(12345),
//                    id: BigInt(12345),
//                    workName: "Piano Sonata No. 14",
//                    catalogueTypeNumDesc: "Op. 27 No. 2",
//                    composer: .init(name: "Ludwig van Beethoven")
//                ),
//                endTime: Date(),
//                movement: .init(name: "I. Adagio sostenuto")
//            )
//        ))
//
//        // In-progress session
//        PracticeSessionView(session: .init(
//            node: .init(
//                id: BigInt(2),
//                startTime: Date().addingTimeInterval(-1800),
//                durationSeconds: nil,
//                piece: .init(
//                    imslpPieceId: BigInt(23456),
//                    id: BigInt(23456),
//                    workName: "Für Elise",
//                    catalogueTypeNumDesc: "WoO 59",
//                    composer: .init(name: "Ludwig van Beethoven")
//                ),
//                endTime: nil,
//                movement: nil
//            )
//        ))
//
//        // Long piece name with full session details
//        PracticeSessionView(session: .init(
//            node: .init(
//                id: BigInt(3),
//                startTime: Date().addingTimeInterval(-7200),
//                durationSeconds: 3600,
//                piece: .init(
//                    imslpPieceId: BigInt(34567),
//                    id: BigInt(34567),
//                    workName: "Piano Sonata No. 14 in C-sharp minor 'Quasi una fantasia'",
//                    catalogueTypeNumDesc: "Op. 27 No. 2",
//                    composer: .init(name: "Ludwig van Beethoven")
//                ),
//                endTime: Date().addingTimeInterval(-3600),
//                movement: .init(name: "III. Presto agitato")
//            )
//        ))
//    }
//    .background(Color(uiColor: .systemGroupedBackground))
// }
//
//// Helper extensions for the preview
// extension RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge {
//    init(node: Node) {
//        self.init(_dataDict: DataDict(
//            data: ["node": node._fieldData],
//            fulfilledFragments: []
//        ))
//    }
// }
//
// extension RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node {
//    init(
//        id: BigInt,
//        startTime: Date,
//        durationSeconds: Int?,
//        piece: Piece,
//        endTime: Date?,
//        movement: Movement?
//    ) {
//        self.init(_dataDict: DataDict(
//            data: [
//                "id": id,
//                "startTime": startTime,
//                "durationSeconds": durationSeconds,
//                "piece": piece._fieldData,
//                "endTime": endTime,
//                "movement": movement._fieldData,
//            ],
//            fulfilledFragments: []
//        ))
//    }
// }
//
// extension RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.Piece {
//    init(
//        imslpPieceId: BigInt,
//        id: BigInt,
//        workName: String,
//        catalogueTypeNumDesc: String? = nil,
//        composer: PieceDetails.Composer? = nil
//    ) {
//        self.init(_dataDict: DataDict(
//            data: [
//                "imslpPieceId": imslpPieceId,
//                "id": id,
//                "workName": workName,
//                "catalogueTypeNumDesc": catalogueTypeNumDesc,
//                "composer": composer._fieldData,
//            ],
//            fulfilledFragments: [ObjectIdentifier(PieceDetails.self)]
//        ))
//    }
// }
//
// extension RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.Movement {
//    init(name: String?) {
//        self.init(_dataDict: DataDict(
//            data: ["name": name],
//            fulfilledFragments: []
//        ))
//    }
// }
