//
//  PracticeSessionManager.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/29/24.
//

import Foundation
import Combine
import Supabase
import os
let logger = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "PracticeSessionManager")

class PracticeSessionManager: ObservableObject {
    @Published var activeSession: PracticeSession?
    private var cancellables: Set<AnyCancellable> = []
    private var currentTaskID: UUID = UUID()

    init() {
        logger.log("In PracticeSessionManager init function \(self.currentTaskID, privacy: .public)")

        subscribeToPracticeSessions()
        fetchCurrentActiveSession()
    }

    func fetchCurrentActiveSession() {
        logger.log("In fetchCurrentActiveSession function \(self.currentTaskID, privacy: .public)")

        Task {
            do {
                // Get current user ID
                let userID = try await Database.getCurrentUser().id
                logger.log("fetchCurrentActiveSession function current user id \(userID) \(self.currentTaskID, privacy: .public)")

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
                    logger.log("No piece found with ID \(response.pieceId ?? "")")
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
                            number: selectedMovement.number,
                            piece: mappedPiece,
                            pieceId: selectedMovement.pieceId
                        ),
                        id: response.id
                    )
                } else {
                    // Initialize without movement details if movementId is nil
                    practiceSession = PracticeSession(
                        start_time: response.startTime!,
                        piece: mappedPiece,
                        id: response.id
                    )
                }
                logger.log("About to dispatch to queue for current session \(self.currentTaskID, privacy: .public)")

                // Update active session on the main queue
                DispatchQueue.main.async {
                    self.activeSession = practiceSession
                }

            } catch {
                logger.log("Error retrieving active session: \(error) \(self.currentTaskID, privacy: .public)")
            }
        }
    }

    func subscribeToPracticeSessions() {
        logger.log("In subscribeToPracticeSessions function \(self.currentTaskID, privacy: .public)")
        Task {
            do {
                guard let userID = try await Database.client.auth.currentUser?.id else {
                    print("No current user found")
                    return
                }
                logger.log("subscribeToPracticeSessions function current user id \(userID, privacy: .public)  \(self.currentTaskID, privacy: .public)")

                let channel = Database.client.realtimeV2.channel("public:practice_sessions")

                let changeStream = channel.postgresChange(
                    AnyAction.self,
                    schema: "public",
                    table: "practice_sessions"
//                    filter: "user_id=eq.\(userID)"
                )

                await channel.subscribe()

                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .formatted(DateFormatter.supabaseIso)

                // Iterate over the change stream
                for try await change in changeStream {
                    logger.log("Found change in change stream \(self.currentTaskID, privacy: .public)")
                    switch change {
                    case .delete(let action):
                        print("Deleted: \(action.oldRecord)")
                    case .insert(let insertion):
                        let practiceSession = try insertion.decodeRecord(decoder: decoder) as PracticeSession
                        logger.log("In changeStream channel function found practice session id: \(practiceSession.id, privacy: .public) \(self.currentTaskID, privacy: .public)")

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
                        logger.log("Dispatching subscribed practice session to mainqueue \(self.currentTaskID, privacy: .public)")
                        DispatchQueue.main.async {
                            self.activeSession = practiceSession
                        }
                    case .update(let action):
                        logger.info("Updated: \(action.oldRecord, privacy: .public) with \(action.record, privacy: .public) \(self.currentTaskID, privacy: .public)")
                        DispatchQueue.main.async {
                            self.activeSession = nil
                        }
                    default:
                        logger.log("An unregistered enum case was encountered  \(self.currentTaskID, privacy: .public)")
                    }
                }
            } catch {
                logger.log("Error in subscribeToPracticeSessions: \(error)  \(self.currentTaskID, privacy: .public)")
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

}
