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
import Supabase

struct EndPracticeSessionIntent: LiveActivityIntent {
    static let client: SupabaseClient = {
        guard let supabaseURL = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String,
              let url = URL(string: supabaseURL)
        else {
            fatalError("Missing Supabase configuration")
        }

        return SupabaseClient(supabaseURL: url, supabaseKey: supabaseKey)
    }()

    static var title: LocalizedStringResource = "End Practice Session"

    func perform() async throws -> some IntentResult {
        do {
            try await endSessionOnServer()
        } catch {
            print("Failed to end session on server: \(error)")
        }

        await endAllLiveActivities()
        return .result()
    }

    private func endSessionOnServer() async throws {
        let defaults = UserDefaults(suiteName: "group.michaelbrandt.PracticeLogger")
        guard let sessionID = defaults?.string(forKey: "currentSessionId") else {
            throw AppIntentError.noSessionID
        }

        // Set auth token from keychain if needed
        let keychain = Keychain(service: "com.brandt.practiceLogger", accessGroup: "PZARYFA5MD.michaelbrandt.PracticeLogger")
        if let accessToken = try? keychain.get("supabaseAccessToken"), let refreshToken = try? keychain.get("supabaseRefreshToken") {
            try await Self.client.auth.setSession(accessToken: accessToken, refreshToken: refreshToken)
        }

        // Update the session with end_time
        try await Self.client
            .from("practice_sessions")
            .update(["end_time": ISO8601DateFormatter().string(from: Date())])
            .eq("id", value: sessionID)
            .execute()
    }

    private func endAllLiveActivities() async {
        for activity in Activity<LiveActivityAttributes>.activities {
            let finalState = LiveActivityAttributes.ContentState(
                startTime: activity.content.state.startTime,
                endTime: Date()
            )
            await activity.end(
                ActivityContent(state: finalState, staleDate: Date()),
                dismissalPolicy: .immediate
            )
        }
    }
}

enum AppIntentError: LocalizedError {
    case noSessionID
    case configurationError

    var errorDescription: String? {
        switch self {
        case .noSessionID: return "No session ID available"
        case .configurationError: return "Configuration error"
        }
    }
}
