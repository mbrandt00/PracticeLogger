//
//  Profile.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Supabase
import SwiftUI

struct Profile: View {
    @State private var sessionInfo: String = ""
    @State private var user: User?
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = ProfileViewModel()
    @EnvironmentObject var sessionManager: PracticeSessionViewModel

    var body: some View {
        VStack {
            if let activeSession = sessionManager.activeSession {
                Text("Active session: \(activeSession.startTime)")
            } else {
                Text("No active session")
            }
            Button("Sign Out") {
                signOut()
            }
            Text(sessionInfo)
                .font(.title)
                .padding(10)
            if let user = user {
                Text("UserId:  \(user.id)")
                    .font(.title)
                    .padding(10)
            }
        }
        .onAppear {
            getInfo()
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

    private func getInfo() {
        Task {
            do {
                let session = try await viewModel.getSessionInfo()
                user = try viewModel.getCurrentUser()
                sessionInfo = "Email: \(session.user.email ?? "")"
            } catch {
                sessionInfo = "Error fetching session: \(error)"
            }
        }
    }
}
