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
        try await Database.shared.client.auth.signOut()
    }
    
    func getSessionInfo() async throws -> Session {
        return try await Database.shared.client.auth.session
    }
}
