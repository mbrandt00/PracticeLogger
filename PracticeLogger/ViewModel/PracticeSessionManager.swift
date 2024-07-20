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
    private var currentTaskID: UUID = UUID()

    init() {
        subscribeToPracticeSessions()
        fetchCurrentActiveSession()
    }
    
    func unsubscribeFromPracticeSessions() {
        Task {
            await Database.client.removeAllChannels()            
        }
    }

    func fetchCurrentActiveSession() {
        Task {
            do {
                // Get current user ID
                let userID = try await Database.getCurrentUser().id
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

                guard let pieceResponse: SupabasePieceResponse = try await Database.client
                    .from("pieces")
                    .select("*, movements!inner(*), composer:composers!inner(id, name)")
                    .eq("id", value: response.pieceId)
                    .single()
                    .execute()
                    .value else {
                        return
                }

                let mappedPiece = mapResponseToFullPiece(response: pieceResponse)
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.supabaseIso)
                var practiceSession: PracticeSession
                
                if let movementId = response.movementId,
                   let selectedMovement = pieceResponse.movements.first(where: { $0.id == movementId }) {
                    practiceSession = PracticeSession(
                        start_time: response.startTime!,
                        movement: Movement(
                            id: selectedMovement.id,
                            name: selectedMovement.name ?? "",
                            number: selectedMovement.number,
                            piece: mappedPiece,
                            pieceId: selectedMovement.pieceId
                        ),
                        id: response.id
                    )
                } else {
                    practiceSession = PracticeSession(
                        start_time: response.startTime!,
                        piece: mappedPiece,
                        id: response.id
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
        let client = Database.client.realtimeV2
        Task {
            do {

                await Database.client.removeAllChannels()

                guard let userId = (Database.client.auth.currentUser?.id) else {
                    print("No current user found")
                    return
                }

                let channel = Database.client.realtimeV2.channel("practice_sessions")

                let changeStream = channel.postgresChange(
                    AnyAction.self,
                    schema: "public",
                    table: "practice_sessions"
//                    filter: "user_id=eq.\(userId)"
                )

                await channel.subscribe()
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.supabaseIso)
                if client.status == .disconnected {
                }

                // Iterate over the change stream
                for try await change in changeStream {
                    print("CHANGE")
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
                                    number: selectedMovementResponse.number,
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
    let id: UUID

    var durationSeconds: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case movementId = "movement_id"
        case pieceId = "piece_id"
        case startTime = "start_time"
        case endTime = "end_time"
        case userId = "user_id"
        case durationSeconds = "durationSeconds"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        pieceId = try container.decodeIfPresent(String.self, forKey: .pieceId)
        movementId = try container.decodeIfPresent(Int.self, forKey: .movementId)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        durationSeconds = try container.decodeIfPresent(Int.self, forKey: .durationSeconds)

        // Decode dates using the supabaseIso formatter
        let dateFormatter = DateFormatter.supabaseIso
        if let startTimeString = try container.decodeIfPresent(String.self, forKey: .startTime) {
            startTime = dateFormatter.date(from: startTimeString)
        }
        if let endTimeString = try container.decodeIfPresent(String.self, forKey: .endTime) {
            endTime = dateFormatter.date(from: endTimeString)
        }
    }
}
