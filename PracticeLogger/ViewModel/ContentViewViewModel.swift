//
//  ContentViewViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/17/24.
//

import Foundation
class ContentViewViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var practiceSessionManager: PracticeSessionManager?
    
    init() {
        performInitialSetup()
    }
    
    private func performInitialSetup() {
        Task {
            do {
                let session = try await Database.client.auth.session
                if !session.isExpired {
                    DispatchQueue.main.async {
                        self.isSignedIn = true
                        self.practiceSessionManager = PracticeSessionManager()
                    }
                } else {
                    try await Database.client.auth.refreshSession()
                    DispatchQueue.main.async {
                        self.isSignedIn = true
                        self.practiceSessionManager = PracticeSessionManager()
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.isSignedIn = false
                    self.practiceSessionManager = nil
                }
            }
        }
    }
}
