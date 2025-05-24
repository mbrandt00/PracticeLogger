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
        let sessionID = try getSessionID()
        let request = try buildEndSessionRequest(sessionID: sessionID)

        try await performEndSessionRequest(request)
        await endAllLiveActivities()

        return .result()
    }

    private func getSessionID() throws -> String {
        let defaults = UserDefaults(suiteName: "group.michaelbrandt.PracticeLogger")
        guard let sessionID = defaults?.string(forKey: "current_session_id") else {
            throw AppIntentError.noSessionID
        }
        return sessionID
    }

    private func buildEndSessionRequest(sessionID: String) throws -> URLRequest {
        let keychain = Keychain(service: "com.brandt.practiceLogger", accessGroup: "PZARYFA5MD.michaelbrandt.PracticeLogger")
        let token = try keychain.getString("supabase_access_token")
        let supabaseKey = try Bundle.main.getRequiredString("SUPABASE_KEY")
        let supabaseURL = try Bundle.main.getRequiredString("SUPABASE_URL")

        guard let url = URL(string: "\(supabaseURL)/rest/v1/practice_sessions?id=eq.\(sessionID)") else {
            throw AppIntentError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setHeaders([
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)",
            "apikey": supabaseKey,
            "Accept": "application/json",
        ])

        let payload = ["end_time": ISO8601DateFormatter().string(from: Date())]
        request.httpBody = try JSONEncoder().encode(payload)

        return request
    }

    private func performEndSessionRequest(_ request: URLRequest) async throws {
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode.isSuccess
        else {
            let message = String(data: data, encoding: .utf8) ?? "Unknown error"
            throw AppIntentError.requestFailed(message)
        }
    }

    private func endAllLiveActivities() async {
        for activity in Activity<LiveActivityAttributes>.activities {
            let finalState = LiveActivityAttributes.ContentState(
                startTime: activity.content.state.startTime,
                endTime: Date()
            )
            await activity.end(ActivityContent(state: finalState, staleDate: Date()), dismissalPolicy: .immediate)
        }
    }
}

enum AppIntentError: LocalizedError {
    case noSessionID
    case missingConfig(String)
    case invalidURL
    case requestFailed(String)
    case tokenNotFound

    var errorDescription: String? {
        switch self {
        case .noSessionID: return "No session ID available"
        case let .missingConfig(key): return "Missing \(key)"
        case .invalidURL: return "Invalid Supabase URL"
        case let .requestFailed(message): return "Failed to end session: \(message)"
        case .tokenNotFound: return "Token not found in keychain"
        }
    }
}

extension Keychain {
    func getString(_ key: String) throws -> String {
        guard let value = try? get(key) else {
            throw AppIntentError.tokenNotFound
        }
        return value
    }
}

extension Bundle {
    func getRequiredString(_ key: String) throws -> String {
        guard let value = infoDictionary?[key] as? String else {
            throw AppIntentError.missingConfig(key)
        }
        return value
    }
}

extension URLRequest {
    mutating func setHeaders(_ headers: [String: String]) {
        for (key, value) in headers {
            setValue(value, forHTTPHeaderField: key)
        }
    }
}

extension Int {
    var isSuccess: Bool { (200 ..< 300).contains(self) }
}
