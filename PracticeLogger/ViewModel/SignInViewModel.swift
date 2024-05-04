//
//  SignInViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Foundation

class SignInViewModel: ObservableObject {
    func signInWithApple(idToken: String) async throws {
        try await Database.client.auth.signInWithIdToken(
            credentials: .init(
                provider: .apple,
                idToken: idToken
            )
        )
    }
    func signInWithEmail() async throws {
        try await Database.client.auth.signIn(email: "test@yahoo.com", password: "password")
    }
}
