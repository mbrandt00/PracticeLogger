//
//  PracticeSessionManager.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/29/24.
//

import Foundation
import Combine
import Supabase

class PracticeSessionManager: ObservableObject {
    @Published var activeSession: PracticeSession?
    private var cancellables: Set<AnyCancellable> = []

    init() {
        subscribeToPracticeSessions()
    }

    func subscribeToPracticeSessions() {
        Task {
            do {
                // Access SupabaseClient from the shared instance
                let channel = try await Database.client.realtimeV2.channel("public:practice_sessions")

                // Safely unwrap the current user
                if let user = Database.client.auth.currentUser {
                    let userID = user.id

                    // Construct the change stream with proper filtering
                    let changeStream = try channel.postgresChange(
                        AnyAction.self,
                        schema: "public",
                        table: "practice_sessions",
                        filter: "user_id=eq.\(userID)"
                    )

                    // Subscribe to the channel
                    await channel.subscribe()

                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601WithoutFractionalSeconds)

                    // Iterate over the change stream
                    for try await change in changeStream {
                        switch change {
                        case .delete(let action):
                            print("Deleted: \(action.oldRecord)")
                            // Handle delete action as needed
                        case .insert(let insertion):

                            let practiceSession = try insertion.decodeRecord(decoder: decoder) as PracticeSession
                            activeSession = practiceSession
                        case .select(let action):
                            print("Selected: \(action.record)")
                            // Handle select action as needed
                        case .update(let action):
                            print("Updated: \(action.oldRecord) with \(action.record)")
                            // Handle update action as needed
                        }
                    }
                } else {
                    print("No current user is logged in")
                }
            } catch {
                print("Error in subscribeToPracticeSessions: \(error)")
            }
        }
    }
}
extension DateFormatter {
    static let iso8601WithoutFractionalSeconds: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
