//
//  SignIn.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import SwiftUI
import Supabase
import AuthenticationServices

struct SignIn: View {
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = SignInViewModel()

    var body: some View {
        SignInWithAppleButton { request in
            request.requestedScopes = [.email, .fullName]
        } onCompletion: { result in
            Task {
                do {
                    guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential
                    else {
                        return
                    }

                    guard let idToken = credential.identityToken
                        .flatMap({ String(data: $0, encoding: .utf8) })
                    else {
                        return
                    }

                    try await viewModel.signInWithApple(idToken: idToken)
                    isSignedIn = true
                } catch {
                    dump(error)
                }
            }
        }
        .fixedSize()
    }
}

#Preview {
    SignIn(isSignedIn: .constant(false))
}
