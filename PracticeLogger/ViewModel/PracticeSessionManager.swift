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
                let channel = Database.client.realtimeV2.channel("public:practice_sessions")
                let userID = try await Database.getCurrentUser().id


                let changeStream =  channel.postgresChange(
                    AnyAction.self,
                    schema: "public",
                    table: "practice_sessions",
                    filter: "user_id=eq.\(userID)"
                )

                await channel.subscribe()

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.supabaseIso)

                // Iterate over the change stream
                for try await change in changeStream {
                    switch change {
                    case .delete(let action):
                        print("Deleted: \(action.oldRecord)")
                    case .insert(let insertion):
                        let practiceSession = try insertion.decodeRecord(decoder: decoder) as PracticeSession
                        activeSession = practiceSession
                    case .update(let action):
                        print("Updated: \(action.oldRecord) with \(action.record)")
                    default:
                        print("An unregistered enum case was encountered")
                    }

                }
            } catch {
                print("Error in subscribeToPracticeSessions: \(error)")
            }
        }
    }
}
