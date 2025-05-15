
//
//  EndPracticeSessionIntent.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/15/25.
//

import AppIntents
import Foundation

struct EndPracticeSessionIntent: AppIntent {
    static var title: LocalizedStringResource = "End Practice Session"
    static var description = IntentDescription("Stops the current practice session.")

    func perform() async throws -> some IntentResult {
        print("Called perform of end practice session intent")
        NotificationCenter.default.post(name: .endPracticeSessionFromWidget, object: nil)
        return .result()
    }
}

extension Notification.Name {
    static let endPracticeSessionFromWidget = Notification.Name("endPracticeSessionFromWidget")
}
