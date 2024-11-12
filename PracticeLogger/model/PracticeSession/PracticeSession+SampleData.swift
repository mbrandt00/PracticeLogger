////
////  PracticeSession+SampleData.swift
////  PracticeLogger
////
////  Created by Michael Brandt on 8/13/24.
////
//
// import ApolloGQL
// import Foundation
//
// extension RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge {
//    static func generateRandomSessions(count: Int) -> [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge] {
//        var sessions: [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge] = []
//
//        for _ in 0 ..< count {
//            let sessionNode = RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node(
//                _dataDict: [
//                    "__typename": "PracticeSessions",
//                    "id": UUID().uuidString,
//                    "startTime": Date().addingTimeInterval(-Double.random(in: 3600...7200)).iso8601String,
//                    "durationSeconds": Int.random(in: 300...3600),
//                    "piece": RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.Piece(
//                        _dataDict: [
//                            "__typename": "Pieces",
//                            "workName": "Work \(Int.random(in: 1...100))",
//                            "composer": RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.Piece.Composer(
//                                _dataDict: [
//                                    "__typename": "Composers",
//                                    "name": "Composer \(Int.random(in: 1...50))"
//                                ]
//                            )
//                        ]
//                    ),
//                    "endTime": Date().addingTimeInterval(-Double.random(in: 0...3600)).iso8601String,
//                    "movement": RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.Movement(
//                        _dataDict: [
//                            "__typename": "Movements",
//                            "name": "Movement \(Int.random(in: 1...10))"
//                        ]
//                    )
//                ]
//            )
//
//            let edge = RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge(
//                _dataDict: [
//                    "__typename": "PracticeSessionsEdge",
//                    "node": sessionNode
//                ]
//            )
//
//            sessions.append(edge)
//        }
//
//        return sessions
//    }
// }
//
//// Helper extension for Date to generate ISO8601 strings
// extension Date {
//    var iso8601String: String {
//        let formatter = ISO8601DateFormatter()
//        return formatter.string(from: self)
//    }
// }
