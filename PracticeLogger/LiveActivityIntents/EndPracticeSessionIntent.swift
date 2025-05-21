//
//  EndPracticeSessionIntent.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/15/25.
//

import ActivityKit
import AppIntents
import Foundation
import KeychainAccess
import SwiftUI

struct EndPracticeSessionIntent: LiveActivityIntent {
    static var title: LocalizedStringResource = "End Practice Session"

    func perform() async throws -> some IntentResult {
        let keychain = Keychain(
            service: "com.brandt.practiceLogger",
            accessGroup: "PZARYFA5MD.michaelbrandt.PracticeLogger"
        )

        guard let token = try? keychain.get("supabase_access_token") else {
            throw NSError(domain: "AppIntent", code: 1, userInfo: [NSLocalizedDescriptionKey: "Token not found in keychain"])
        }

        let defaults = UserDefaults(suiteName: "group.michaelbrandt.PracticeLogger")
        guard let sessionID = defaults?.string(forKey: "current_session_id") else {
            throw NSError(domain: "AppIntent", code: 1, userInfo: [NSLocalizedDescriptionKey: "No session ID available"])
        }
        // Make the PATCH request to Supabase
        guard let supabaseUrlString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String
        else {
            fatalError("Missing SUPABASE_URL for endpracticesession intent")
        }

        guard let url = URL(string: "\(supabaseUrlString)/rest/v1/practice_sessions?id=eq.\(sessionID)") else {
            throw NSError(domain: "AppIntent", code: 2, userInfo: [NSLocalizedDescriptionKey: "Invalid Supabase URL"])
        }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let payload = ["end_time": ISO8601DateFormatter().string(from: Date())]
        request.httpBody = try JSONEncoder().encode(payload)
        dump(request)
        print("HERE")
        NSLog("Preparing to PATCH to supabase api")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200 ..< 300).contains(httpResponse.statusCode)
        else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown"
            throw NSError(
                domain: "AppIntent",
                code: 3,
                userInfo: [NSLocalizedDescriptionKey: "Failed to end session: \(message)"]
            )
        }

        for activity in Activity<LiveActivityAttributes>.activities {
            NSLog("Ending Live Activity: \(activity.id)")
            let finalState = LiveActivityAttributes.ContentState(
                startTime: activity.content.state.startTime,
                endTime: Date()
            )
            let finalContent = ActivityContent(state: finalState, staleDate: Date())
            await activity.end(finalContent, dismissalPolicy: .immediate)
        }

        return .result()
    }
}
