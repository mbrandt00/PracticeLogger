//
//  GlobalSettings.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/18/25.
//

import Foundation

enum GlobalSettings {
    static var baseApiUrl: String? {
        // First try Info.plist (for TestFlight/Production)
        if let plistValue = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String, !plistValue.isEmpty {
            return plistValue
        }

        // Then fall back to environment (for development)
        return ProcessInfo.processInfo.environment["SUPABASE_URL"]
    }

    static var apiServiceKey: String? {
        // First try Info.plist (for TestFlight/Production)
        if let plistValue = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String, !plistValue.isEmpty {
            return plistValue
        }

        // Then fall back to environment (for development)
        return ProcessInfo.processInfo.environment["SUPABASE_KEY"]
    }
}
