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
                        if practiceSession.pieceId != nil {
                            let piece: SupabasePieceResponse = try await Database.client
                                .from("pieces")
                                .select("*, movements!inner(*), composer:composers!inner(id, name)")
                                .eq("id", value: practiceSession.pieceId)
                                .single()
                                .execute()
                                .value
                            practiceSession.piece = mapToModels(response: piece)
//
                            activeSession = practiceSession
                        }
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
struct SupabasePieceResponse: Codable {
    let id: UUID
    let workName: String
    let composerId: Int?
    let userId: UUID
    let format: String?
    let keySignature: String?
    let tonality: String?
    let catalogueType: String?
    let catalogueNumber: Int?
    let updatedAt: String?
    let createdAt: String?
    let nickname: String?
    let name: String?
    let number: Int?
    let movements: [MovementResponse]
    let composer: ComposerResponse?

    enum CodingKeys: String, CodingKey {
        case id
        case workName = "work_name"
        case composerId = "composer_id"
        case userId = "user_id"
        case format
        case keySignature = "key_signature"
        case tonality
        case catalogueType = "catalogue_type"
        case catalogueNumber = "catalogue_number"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case nickname
        case name
        case number
        case movements // Nested movements
        case composer
    }
}

struct MovementResponse: Codable {
    let id: Int
    let name: String?
    let number: Int?
    let pieceId: UUID

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case number
        case pieceId = "piece_id"
    }
}
struct ComposerResponse: Codable {
    let id: Int
    let name: String
}
func mapToModels(response: SupabasePieceResponse) -> Piece {
        let pieceId = response.id.uuidString

            let composer = Composer(
                name: response.composer?.name ?? "Unknown Composer",
                id: response.composer?.id ?? 0
            )
            let piece = Piece(
                workName: response.workName,
                composer: composer,
                movements: [],
                catalogue_type: CatalogueType(rawValue: response.catalogueType ?? ""),
                catalogue_number: response.catalogueNumber ?? 0,
                format: Format(rawValue: response.format ?? ""),
                nickname: response.nickname,
                tonality: KeySignatureTonality(rawValue: response.tonality ?? ""),
                key_signature: KeySignatureType(rawValue: response.keySignature ?? "")
            )

        for movementResponse in response.movements {
            let movement = Movement(
                id: movementResponse.id,
                name: movementResponse.name ?? "",
                number: movementResponse.number ?? 0,
                piece: piece,
                pieceId: movementResponse.pieceId
            )
        }
    return piece
}
