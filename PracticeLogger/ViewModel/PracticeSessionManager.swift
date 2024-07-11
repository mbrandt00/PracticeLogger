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
                        let piece: SupabasePieceResponse = try await Database.client
                            .from("pieces")
                            .select("*, movements!inner(*), composer:composers!inner(id, name)")
                            .eq("id", value: practiceSession.pieceId)
                            .single()
                            .execute()
                            .value
                        practiceSession.piece = mapResponseToFullPiece(response: piece)
                        if let movementId = practiceSession.movementId {
                            let selectedMovementResponse = piece.movements.first { $0.id == movementId }
                            if let selectedMovementResponse = selectedMovementResponse {
                                let selectedMovement = Movement(
                                    id: selectedMovementResponse.id,
                                    name: selectedMovementResponse.name ?? "",
                                    number: selectedMovementResponse.number ?? 0,
                                    piece: practiceSession.piece,
                                    pieceId: selectedMovementResponse.pieceId
                                )
                                practiceSession.movement = selectedMovement
                            } else {
                                // Handle case where no matching movement is found
                                print("No matching movement found for id \(movementId)")
                            }
                        }
                        DispatchQueue.main.async {
                            self.activeSession = practiceSession
                        }
                    case .update(let action):
                        print("Updated: \(action.oldRecord) with \(action.record)")
                        DispatchQueue.main.async {
                            self.activeSession = nil
                        }
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
