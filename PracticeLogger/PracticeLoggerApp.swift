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
    @State private var isLoading = true
    @StateObject private var toastManager = GlobalToastManager()

    init() {
        DispatchQueue.main.async {
            UITextField.appearance().clearButtonMode = .whileEditing
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                if isLoading {
                    ProgressView("Loading...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                } else {
                    ContentView(isSignedIn: $isSignedIn)
                        .environmentObject(toastManager)
                }
            }
            .task {
                await updateSignInStatus()
            }
        }
    }

    private func updateSignInStatus() async {
        do {
            let session = try await Database.client.auth.session
            isSignedIn = !session.isExpired
        } catch {
            print("Error fetching session: \(error)")
            isSignedIn = false
        }
        isLoading = false
    }
}
