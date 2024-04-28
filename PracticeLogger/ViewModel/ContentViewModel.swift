//
//  ContentViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/28/24.
//

import Foundation

import Supabase
class ContentViewModel: ObservableObject {
    func getUser() async throws -> User {
        try await Database.shared.client.auth.session.user
    }

    func getSessionInfo() async throws -> Session {
        return try await Database.shared.client.auth.session
    }
}
