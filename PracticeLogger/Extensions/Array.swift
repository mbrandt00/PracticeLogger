//
//  Array.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 8/13/24.
//

import ApolloGQL
import Foundation

extension Array where Element == RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge {
    var groupedByDay: [Date: [RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge]] {
        Dictionary(grouping: self) { edge in
            Calendar.current.startOfDay(for: edge.node.endTime ?? Date())
        }
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
