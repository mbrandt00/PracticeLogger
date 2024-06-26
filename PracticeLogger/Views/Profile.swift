//
//  Profile.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import SwiftUI

struct Profile: View {
    @State private var sessionInfo: String = ""
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = ProfileViewModel()

    var body: some View {
        VStack {
            Button("Sign Out") {
                signOut()
            }
            Text(sessionInfo)
                .font(.title)
                .padding(10)
        }
        .onAppear {
            getSessionInfo()
        }
    }

    private func signOut() {
        Task {
            do {
                try await viewModel.signOut()
                isSignedIn = false
            } catch {
                print("Error signing out: \(error)")
            }
        }
    }

    private func getSessionInfo() {
        Task {
            do {
                let session = try await viewModel.getSessionInfo()
                sessionInfo = "Email: \(session.user.email ?? "")"
            } catch {
                sessionInfo = "Error fetching session: \(error)"
            }
        }
    }
}
