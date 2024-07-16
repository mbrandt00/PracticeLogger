//
//  PracticeSession.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import Foundation

class PracticeSession: ObservableObject, Identifiable, Codable, Equatable {

    let id: UUID
    @Published var startTime: Date
    @Published var endTime: Date?
    @Published var piece: Piece? // Piece object
    @Published var composer: Composer?
    var pieceId: UUID // ID to fetch Piece
    var movementId: Int?
    var userId: UUID?
    @Published var movement: Movement?

    enum CodingKeys: String, CodingKey {
        case id
        case startTime = "start_time"
        case endTime = "end_time"
        case pieceId = "piece_id"
        case movementId = "movement_id"
        case userId = "user_id"
    }

    // Initialize PracticeSession from decoder
    init(start_time: Date, piece: Piece? = nil, movement: Movement? = nil, id: UUID = UUID()) {
        self.id = id
        self.startTime = start_time
        self.endTime = nil
        self.movement = movement

        if let movement = movement {
            self.piece = movement.piece
            self.pieceId = movement.piece!.id
        } else {
            self.piece = piece
            self.pieceId = piece!.id
        }
    }

    // Codable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decodeIfPresent(Date.self, forKey: .endTime)
        pieceId = try container.decodeIfPresent(UUID.self, forKey: .pieceId) ?? UUID() // Initialize pieceId with decoded value or a new UUID
        movementId = try container.decodeIfPresent(Int.self, forKey: .movementId)
        userId = try container.decodeIfPresent(UUID.self, forKey: .userId)
    }

    // Codable encode method
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(startTime, forKey: .startTime)
        try container.encodeIfPresent(endTime, forKey: .endTime)
        try container.encodeIfPresent(piece?.id, forKey: .pieceId)
        try container.encodeIfPresent(movement?.id, forKey: .movementId)
    }

    static func == (lhs: PracticeSession, rhs: PracticeSession) -> Bool {
        return lhs.id == rhs.id
    }

    func stopSession() async {
        print("IN STOP SESSION")
        do {
            let response = try await Database.client
                        .from("practice_sessions")
                        .update(["end_time": Date()])
                        .eq("id", value: id)
                        .execute()
        } catch {
            print("Error updating end_time: \(error)")
        }
    }
}

struct PracticeSessionResponse: Decodable {
    var endTime: Date?
    var startTime: Date?
    var id: String?
    var movementId: Int?
    var userId: String?
    var durationSeconds: String?
    enum CodingKeys: String, CodingKey {
        case endTime = "end_time"
        case startTime = "start_time"
        case movementId = "movement_id"
        case userId = "user_id"
        case durationSeconds = "duration_seconds"
    }

}
