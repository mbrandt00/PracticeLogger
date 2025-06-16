//
//  RecentlyDeleted.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/25.
//

import ApolloGQL
import Foundation
import SwiftUI

struct RecentlyDeleted: View {
    @Binding var deletedSessions: [PracticeSessionDetails]

    var body: some View {
        if deletedSessions.isEmpty {
            Text("No recently deleted sessions.")
                .padding()
        } else {
            List {
                Section(header:
                    Text("Swipe left on a session to restore it. Deleted sessions are permanently removed after 30 days.")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                ) {
                    ForEach(deletedSessions, id: \.id) { session in
                        RecentPracticeSessionListItem(session: session)
                            .swipeActions(allowsFullSwipe: true) {
                                Button(role: .cancel) {
                                    Task {
                                        do {
                                            let updateData: [String: String?] = [
                                                "deleted_at": nil
                                            ]

                                            _ = try await Database.client
                                                .from("practice_sessions")
                                                .update(updateData)
                                                .eq("id", value: session.id)
                                                .execute()

                                            if let index = deletedSessions.firstIndex(where: { $0.id == session.id }) {
                                                await MainActor.run {
                                                    withAnimation {
                                                        deletedSessions.remove(at: index)
                                                    }
                                                }
                                            }

                                        } catch {
                                            print(error)
                                        }
                                    }
                                } label: {
                                    Label("Undo delete", systemImage: "arrow.uturn.backward")
                                }
                            }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Deleted sessions")
        }
    }
}

#Preview {
    RecentlyDeleted(deletedSessions: .constant(PracticeSessionDetails.allPreviews))
}
