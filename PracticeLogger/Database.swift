//
//  Database.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Foundation
import Supabase

class Database: ObservableObject {
    static let client: SupabaseClient = {
        guard let supabaseUrlString = GlobalSettings.baseApiUrl,
              let supabaseUrl = URL(string: supabaseUrlString),
              let supabaseKey = GlobalSettings.apiServiceKey
        else {
            fatalError("Missing SUPABASE_URL or SUPABASE_KEY in Environment")
        }

        return SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey
//            options: SupabaseClientOptions()
        )
    }()

    @Published var isLoggedIn: Bool = false

    static func getCurrentUser() throws -> User? {
        return Database.client.auth.currentUser
    }
}
