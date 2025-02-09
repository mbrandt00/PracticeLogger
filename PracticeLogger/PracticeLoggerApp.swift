//
//  PracticeLoggerApp.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI

@main
struct PracticeLoggerApp: App {
    @State private var isSignedIn = false
    init() {
        DispatchQueue.main.async {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }

    var body: some Scene {
        WindowGroup {
            ContentView(isSignedIn: $isSignedIn)
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
