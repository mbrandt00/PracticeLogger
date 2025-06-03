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
    @State private var isShowingEmailSheet: Bool = false
    @State private var authMode: AuthMode = .logIn
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(spacing: 32) {
            Text("Practice Logger")
                .font(.largeTitle.bold())
                .multilineTextAlignment(.center)
                .padding(.top, 40)

            VStack(spacing: 16) {
                SignInWithAppleButton { request in
                    request.requestedScopes = [.email, .fullName]
                } onCompletion: { result in
                    Task {
                        do {
                            guard let credential = try result.get().credential as? ASAuthorizationAppleIDCredential,
                                  let idToken = credential.identityToken.flatMap({ String(data: $0, encoding: .utf8) }) else { return }

                            try await viewModel.signInWithApple(idToken: idToken)
                            isSignedIn = true
                        }
                    }
                }
                .signInWithAppleButtonStyle(colorScheme == .dark ? .black : .whiteOutline)
                .frame(maxWidth: 280, maxHeight: 45)
            }

            Divider().padding(.horizontal)

            Button("Sign in with Email") {
                authMode = .logIn
                isShowingEmailSheet = true
            }

            Button("Sign up with Email") {
                authMode = .signUp
                isShowingEmailSheet = true
            }

#if DEBUG
            Divider().padding(.top)

            Button("Dev Sign In") {
                Task {
                    do {
                        try await viewModel.quickSignInDev()
                        isSignedIn = true
                    }
                }
            }
            .foregroundColor(.red)
#endif

            Spacer()
        }
        .padding()
        .sheet(isPresented: $isShowingEmailSheet) {
            EmailAuthForm(
                isPresented: $isShowingEmailSheet,
                isSignedIn: $isSignedIn,
                mode: $authMode,
                viewModel: viewModel
            )
            .presentationDetents([.height(280)])
            .presentationDragIndicator(.visible)
        }
        .toast(isPresenting: $isShowingToast) {
            AlertToast(type: .error(.red), title: errorMessage)
        }
    }
}

struct SignIn_Previews: PreviewProvider {
    static var previews: some View {
        SignIn(isSignedIn: .constant(false))
    }
}

enum AuthMode {
    case logIn
    case signUp

    var title: String {
        switch self {
        case .logIn: return "Log In"
        case .signUp: return "Sign Up"
        }
    }
}
