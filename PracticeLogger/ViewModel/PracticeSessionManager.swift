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
        fetchCurrentActiveSession()
    }

    func fetchCurrentActiveSession() {
        Task {
            do {
                // Get current user ID
                let userID = try await Database.getCurrentUser().id

                // Fetch active session response
                guard let response: ActiveSessionResponse = try await Database.client
                    .from("practice_sessions")
                    .select("*")
                    .eq("user_id", value: userID)
                    .is("end_time", value: nil)
                    .single()
                    .execute()
                    .value else {
                        print("No active session found for user \(userID)")
                        return
                }

                // Fetch piece details for the active session
                guard let pieceResponse: SupabasePieceResponse = try await Database.client
                    .from("pieces")
                    .select("*, movements!inner(*), composer:composers!inner(id, name)")
                    .eq("id", value: response.pieceId)
                    .single()
                    .execute()
                    .value else {
                        print("No piece found with ID \(response.pieceId)")
                        return
                }

                // Map piece response to a full piece object
                let mappedPiece = mapResponseToFullPiece(response: pieceResponse)

                // Initialize practice session based on response data
                var practiceSession: PracticeSession

                if let movementId = response.movementId,
                   let selectedMovement = pieceResponse.movements.first(where: { $0.id == movementId }) {
                    // Initialize with movement details if movementId is present
                    practiceSession = PracticeSession(
                        start_time: response.startTime!,
                        movement: Movement(
                            id: selectedMovement.id,
                            name: selectedMovement.name ?? "",
                            number: selectedMovement.number ?? 0,
                            piece: mappedPiece,
                            pieceId: selectedMovement.pieceId
                        )
                    )
                } else {
                    // Initialize without movement details if movementId is nil
                    practiceSession = PracticeSession(
                        start_time: response.startTime!,
                        piece: mappedPiece
                    )
                }

                // Update active session on the main queue
                DispatchQueue.main.async {
                    self.activeSession = practiceSession
                }

            } catch {
                print("Error retrieving active session: \(error)")
            }
        }
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
struct ActiveSessionResponse: Decodable {
    var pieceId: String?
    var movementId: Int?
    var startTime: Date?
    var endTime: Date?
    var userId: String?
    var durationSeconds: Int?
    enum CodingKeys: String, CodingKey {
        case movementId = "movement_id"
        case pieceId = "piece_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case userId = "user_id"
        case durationSeconds = "durationSeconds"
    }

}
