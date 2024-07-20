//
//  Profile.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import SwiftUI
import Supabase
struct Profile: View {
    @State private var sessionInfo: String = ""
    @State private var user: User? = nil
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = ProfileViewModel()
    @EnvironmentObject var practiceSessionManager: PracticeSessionManager

    var body: some View {
        VStack {
            if let user = user {
                Text("UserId:  \(user.id)")
            }
            if let activeSession = practiceSessionManager.activeSession {
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
                let user = try await viewModel.getCurrentUser()
                sessionInfo = "Email: \(session.user.email ?? "")"
            } catch {
                sessionInfo = "Error fetching session: \(error)"
            }
        }
    }
}
