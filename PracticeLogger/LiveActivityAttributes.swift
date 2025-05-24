//
//  LiveActivityAttributes.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/13/25.
//

import ActivityKit
import SwiftUI

struct LiveActivityAttributes: ActivityAttributes, Codable {
    public typealias TimerStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var startTime: Date
        var endTime: Date?
    }

    // attributes that dont change go outside of content state
    var pieceName: String
    var movementName: String?
    var movementNumber: Int?
}
