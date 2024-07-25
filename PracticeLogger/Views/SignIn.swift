//
//  SignIn.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import AlertToast
import AuthenticationServices
import Supabase
import SwiftUI

struct SignIn: View {
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = SignInViewModel()
    @State private var errorMessage: String = ""
    @State private var isShowingToast: Bool = false
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
                    } catch AuthError.notSignedIn {
                        errorMessage = "Sign In With Apple not enabled"
                    } catch {
                        errorMessage = "An unexpected error occurred: \(error.localizedDescription)."
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        errorMessage = "" // Clear error message after 2 seconds
                    }
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
                    errorMessage = error.localizedDescription
                }
            }
        }
        #endif
        if !errorMessage.isEmpty {
            AlertToast(type: .error(.red), title: errorMessage)
                .padding()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        errorMessage = ""
                    }
                }
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(isSignedIn: .constant(false))
    }
}
