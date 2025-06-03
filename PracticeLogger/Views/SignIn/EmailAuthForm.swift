//
//  EmailAuthForm.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/1/25.
//
import SwiftUI

struct EmailAuthForm: View {
    @Binding var isPresented: Bool
    @Binding var isSignedIn: Bool
    @Binding var mode: AuthMode
    var viewModel: SignInViewModel

    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage = ""

    var body: some View {
        GeometryReader { _ in
            NavigationView {
                VStack(spacing: 20) {
                    VStack(spacing: 16) {
                        TextField("Email", text: $email)
                            .textContentType(.emailAddress)
                            .autocapitalization(.none)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .disableAutocorrection(true)

                        SecureField("Password", text: $password)
                            .textContentType(.password)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding()
                    if !errorMessage.isEmpty {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.horizontal)
                            .multilineTextAlignment(.center)
                            .lineLimit(nil)
                    }
                    Button(mode.title) {
                        Task {
                            do {
                                switch mode {
                                case .logIn:
                                    try await viewModel.logInWithEmail(email: email, password: password)
                                case .signUp:
                                    try await viewModel.signUpWithEmail(email: email, password: password)
                                }
                                isSignedIn = try await !Database.client.auth.session.isExpired
                                isPresented = false
                            } catch {
                                errorMessage = error.localizedDescription
                            }
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.horizontal)

                    Spacer()
                }
                .navigationTitle(mode.title)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            isPresented = false
                        }
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

enum AuthFormError {
    case custom(AuthError)
    case message(String)
}
