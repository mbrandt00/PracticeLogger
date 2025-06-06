//
//  Profile.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Supabase
import SwiftUI

struct Settings: View {
    @State private var user: User?
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = ProfileViewModel()
    @EnvironmentObject var sessionManager: PracticeSessionViewModel

    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink("Submit feedback", destination: FeedbackView())
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
                }
            }
            .navigationTitle("Settings")
        }
    }
}
