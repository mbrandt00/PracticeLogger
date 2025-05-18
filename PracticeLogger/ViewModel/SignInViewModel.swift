//
//  SignInViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Foundation
import KeychainAccess

class SignInViewModel: ObservableObject {
    func signInWithApple(idToken: String) async throws {
        try await Database.client.auth.signInWithIdToken(
            credentials: .init(
                provider: .apple,
                idToken: idToken
            )
        )
        let token = try await Database.client.auth.session.accessToken
        saveTokenToKeychain(token)
    }

    func signInWithEmail() async throws {
        try await Database.client.auth.signIn(email: "test@yahoo.com", password: "password")
        let token = try await Database.client.auth.session.accessToken
        print("SINGI N WITH EMAIL TOKEN")
        saveTokenToKeychain(token)
    }

    func saveTokenToKeychain(_ token: String) {
        print("🔐 Saving token to Keychain: \(token.prefix(16))...")

        let keychain = Keychain(
            service: "com.brandt.practiceLogger",
            accessGroup: "PZARYFA5MD.michaelbrandt.PracticeLogger"
        )
        do {
            try keychain.set(token, key: "supabase_access_token")
            print("Using access group: \(keychain.accessGroup ?? "nil")")

            print("✅ Token saved successfully")
        } catch {
            print("❌ Failed to save token: \(error)")
        }
    }
}
