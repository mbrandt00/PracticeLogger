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

struct EndPracticeSessionIntent: AppIntent {
    static var title: LocalizedStringResource = "End Practice Session"

    func perform() async throws -> some IntentResult {
        let keychain = Keychain(
            service: "com.brandt.practiceLogger",
            accessGroup: "michaelbrandt.PracticeLogger.shared"
        )

        guard let token = try? keychain.get("supabase_access_token") else {
            throw NSError(domain: "AppIntent", code: 1, userInfo: [NSLocalizedDescriptionKey: "Token not found in keychain"])
        }

        // You also need the session ID – load it from shared defaults:
        let defaults = UserDefaults(suiteName: "group.michaelbrandt.PracticeLogger")
        guard let sessionID = defaults?.string(forKey: "current_session_id") else {
            throw NSError(domain: "AppIntent", code: 1, userInfo: [NSLocalizedDescriptionKey: "No session ID available"])
        }
        // Make the PATCH request to Supabase
        guard let supabaseUrlString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String
        else {
            fatalError("Missing SUPABASE_URL for Graphql URL")
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
        NSLog("Posted successfully, attempting to end activity", response)

        Task {
            for activity in Activity<LiveActivityAttributes>.activities {
                NSLog("Ending Live Activity: \(activity.id)")
                await activity.end(nil, dismissalPolicy: .immediate)
            }
        }

        return .result()
    }
}
