//
//  Array.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/13/24.
//

import Foundation

extension Array where Element == PracticeSession {
    var groupedByDay: [Date: [PracticeSession]] {
        Dictionary(grouping: self) { session in
            Calendar.current.startOfDay(for: session.endTime ?? Date())
        }
    }

    var groupedByDayAndPiece: [Date: [Piece: [PracticeSession]]] {
        let groupedByDay = self.groupedByDay
        var result = [Date: [Piece: [PracticeSession]]]()

        for (day, sessions) in groupedByDay {
            let groupedByPiece = Dictionary(grouping: sessions) { session -> Piece? in
                session.piece
            }
            // Filter out nil pieces
            let nonNilGroupedByPiece = groupedByPiece.filter { $0.key != nil }
            // Cast keys to non-optional
            let nonNilGroupedByPieceCast = nonNilGroupedByPiece.mapKeys { $0! }
            result[day] = nonNilGroupedByPieceCast
        }
        return result
    }
}

// Helper extension to map dictionary keys
extension Dictionary {
    func mapKeys<T: Hashable>(_ transform: (Key) -> T) -> [T: Value] {
        var result = [T: Value]()
        for (key, value) in self {
            result[transform(key)] = value
        }
        return result
    }
}
