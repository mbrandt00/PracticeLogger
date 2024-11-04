//
//  Supabase.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Foundation
import Supabase

class Database: ObservableObject {
    static let client: SupabaseClient = {
        guard let supabaseUrlString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseUrl = URL(string: supabaseUrlString),
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String
        else {
            fatalError("Missing SUPABASE_URL or SUPABASE_KEY in Info.plist")
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
