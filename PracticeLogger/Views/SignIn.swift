//
//  SignIn.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import SwiftUI
import Supabase
import AuthenticationServices
import AlertToast

struct SignIn: View {
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = SignInViewModel()
    @State private var showToast: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            SignInWithAppleButton { request in
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                Task {
                    do {
                        guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential else {
                            return
                        }

                        guard let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else {
                            return
                        }

                        try await viewModel.signInWithApple(idToken: idToken)
                        isSignedIn = true
                    } catch {
                        if let error = error as? AuthError {
                            switch error {
                            case .signInAppleNotEnabled:
                                errorMessage = "Sign In With Apple not enabled"
                            }
                        } else {
                            errorMessage = "An unexpected error occurred."
                        }
                        showToast = true
                        errorMessage = error.localizedDescription // Corrected assigning error message
                    }
                }
            }
            .fixedSize()

            #if DEBUG
            Button("Test Account") {
                Task {
                    do {
                        try await viewModel.signInWithEmail()
                        isSignedIn = true
                    } catch {
                        showToast = true
                        errorMessage = error.localizedDescription // Corrected assigning error message
                    }
                }
            }
            #endif
            if errorMessage != "" {
                Text(errorMessage)
            }
        }
        .toast(isPresenting: $showToast) {
            AlertToast(type: .error(.red), title: errorMessage, style: AlertToast.AlertStyle.style(titleFont: .caption2))
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(isSignedIn: .constant(false))
    }
}
