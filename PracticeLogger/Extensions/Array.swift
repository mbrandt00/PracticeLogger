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
            // Use only year, month, and day components for grouping
            Calendar.current.startOfDay(for: session.endTime ?? Date())
        }
    }
}
