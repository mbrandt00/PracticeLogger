//
//  Profile.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import SwiftUI

struct Profile: View {
    @State var sessionInfo: String = ""
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = ProfileViewModel()
    var body: some View {
        VStack {
            Button("Sign Out") {
                Task {
                    do {
                        try await viewModel.signOut()
                        isSignedIn = false
                    } catch {
                        print("Error signing out: \(error)")
                    }
                }
            }
            Text(sessionInfo)
                .onAppear {
                    Task {
                        do {
                            let session = try await viewModel.getSessionInfo()
                            let info = """
                            Session info:
                            - access token: \(session.accessToken)
                            - expires in: \(session.expiresIn)
                            - token type: \(session.tokenType)
                            - user ID: \(session.user.id)
                            - user email: \(session.user.email)
                            """
                            sessionInfo = info
                        } catch {
                            sessionInfo = "Error fetching session: \(error)"
                        }
                    }
                }
        }
    }
}
