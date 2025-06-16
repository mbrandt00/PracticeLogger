//
//  Settings.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import ApolloGQL
import Supabase
import SwiftUI

struct Settings: View {
    @State private var user: User?
    @State private var recentlyDeletedSessions: [PracticeSessionDetails] = []
    @Binding var isSignedIn: Bool
    @ObservedObject var viewModel = ProfileViewModel()
    @EnvironmentObject var sessionManager: PracticeSessionViewModel

    var deletedCount: Int {
        recentlyDeletedSessions.count
    }

    var body: some View {
        NavigationView {
            VStack {
                List {
                    NavigationLink("Submit feedback", destination: FeedbackView())

                    NavigationLink(destination: RecentlyDeleted(deletedSessions: $recentlyDeletedSessions)) {
                        HStack(alignment: .center) {
                            Text("Recently deleted")

                            Spacer()

                            if deletedCount > 0 {
                                let badgeText = deletedCount > 99 ? "99+" : "\(deletedCount)"

                                Text(badgeText)
                                    .font(.caption2)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(
                                        Capsule()
                                            .fill(Color.red)
                                    )
                                    .accessibilityLabel("\(deletedCount) deleted pieces")
                            }
                        }
                    }
                    .disabled(deletedCount == 0)

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
        .onAppear(perform: fetchRecentlyDeleted)
    }

    private func fetchRecentlyDeleted() {
        Task {
            do {
                let userId = try await Database.client.auth.user().id.uuidString

                let result = try await withCheckedThrowingContinuation { continuation in
                    Network.shared.apollo.fetch(query: RecentlyDeletedSessionsQuery(userId: userId), cachePolicy: .fetchIgnoringCacheCompletely) { result in
                        switch result {
                        case let .success(graphQlResult):
                            if let sessions = graphQlResult.data?.practiceSessionsCollection?.edges {
                                continuation.resume(returning: sessions.compactMap { $0.node.fragments.practiceSessionDetails })
                            } else {
                                continuation.resume(returning: [])
                            }

                        case let .failure(error):
                            continuation.resume(throwing: error)
                        }
                    }
                }

                self.recentlyDeletedSessions = result
            } catch {
                print("Error fetching recent sessions: \(error)")
            }
        }
    }
}

struct SettingsPreviewWrapper: View {
    @State private var isSignedIn = true
    @State private var recentlyDeletedSessions = PracticeSessionDetails.allPreviews

    var body: some View {
        Settings(
            isSignedIn: $isSignedIn,
            viewModel: ProfileViewModel()
        )
        .environmentObject(PracticeSessionViewModel())
        .onAppear {
            recentlyDeletedSessions = PracticeSessionDetails.allPreviews
        }
    }
}

#Preview {
    SettingsPreviewWrapper()
}
