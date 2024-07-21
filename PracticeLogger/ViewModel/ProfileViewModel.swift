//
//  ProfileViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Foundation
import Supabase
class ProfileViewModel: ObservableObject {
    func signOut() async throws {
        try await Database.client.auth.signOut()
    }

    func getSessionInfo() async throws -> Session {
        return try await Database.client.auth.session
    }

    func getCurrentUser() async throws -> User? {
        return try await Database.client.auth.currentUser
    }
}
