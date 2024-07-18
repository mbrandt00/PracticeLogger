//
//  PracticeLoggerApp.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI

@main
struct PracticeLoggerApp: App {
    @StateObject private var manager = PracticeSessionManager()
    @State private var isSignedIn = false

    var body: some Scene {
        WindowGroup {
            ContentView(isSignedIn: $isSignedIn)
                .environmentObject(manager)
                .onAppear {
                    updateSignInStatus()
                }
        }
    }

    private func updateSignInStatus() {
        Task {
            do {
                let session = try await Database.client.auth.session
                if session.isExpired {
                    isSignedIn = false
                } else {
                    isSignedIn = true
                }
            } catch {
                print("Error fetching session: \(error)")
                isSignedIn = false
            }
        }
    }
}
