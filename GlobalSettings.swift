//
//  GlobalSettings.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/18/25.
//

import Foundation

enum GlobalSettings {
    static var baseApiUrl: String? {
        let key = "SUPABASE_URL"
        guard ProcessInfo.processInfo.environment.contains(where: { $0.key == key }) else { return nil }
        return ProcessInfo.processInfo.environment[key]
    }

    static var apiServiceKey: String? {
        let key = "SUPABASE_KEY"
        guard ProcessInfo.processInfo.environment.contains(where: { $0.key == key }) else { return nil }
        return ProcessInfo.processInfo.environment[key]
    }
}
