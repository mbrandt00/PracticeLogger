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
    }

    func signUpWithEmail(email: String, password: String) async throws {
        let response = try await Database.client.auth.signUp(email: email, password: password)
        if response.session == nil, response.user.emailConfirmedAt == nil {
            throw AuthError.emailConfirmationRequired
        }
    }

    func logInWithEmail(email: String, password: String) async throws {
        do {
            _ = try await Database.client.auth.signIn(email: email, password: password)
        } catch {
            let message = (error as? LocalizedError)?.errorDescription ?? error.localizedDescription

            if message.contains("Email not confirmed") {
                throw AuthError.emailConfirmationRequired
            } else {
                throw error
            }
        }
    }

    #if DEBUG
        func quickSignInDev() async throws {
            try await logInWithEmail(email: "test@yahoo.com", password: "password")
        }
    #endif
}

enum AuthError: LocalizedError {
    case emailConfirmationRequired, notSignedIn, signInAppleNotEnabled

    var errorDescription: String? {
        switch self {
        case .emailConfirmationRequired:
            return "Please check your email to confirm your account before signing in."

        case .notSignedIn:
            return "Not signed in"

        case .signInAppleNotEnabled:
            return "Sign in with apple is not enabled"
        }
    }
}
