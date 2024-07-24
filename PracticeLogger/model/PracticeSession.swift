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
    @Published var piece: Piece?
    @Published var composer: Composer?
    @Published var pieceId: UUID
    @Published var movementId: Int?
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

init(start_time: Date, piece: Piece? = nil, movement: Movement? = nil, id: UUID = UUID()) {
    self.id = id
    self.startTime = start_time
    self.endTime = nil
    self.movement = movement
    self.movementId = movement?.id
    self.piece = movement?.piece ?? piece
    self.pieceId = movement?.piece?.id ?? piece?.id ?? UUID() 
}

    // Codable initializer
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)

        // Decode startTime from String
        let startTimeString = try container.decode(String.self, forKey: .startTime)
        guard let startDate = DateFormatter.supabaseIso.date(from: startTimeString) else {
            throw DecodingError.dataCorruptedError(forKey: .startTime, in: container, debugDescription: "Invalid date format: \(startTimeString)")
        }
        startTime = startDate

        // Decode endTime from String if present
        if let endTimeString = try container.decodeIfPresent(String.self, forKey: .endTime) {
            if let endDate = DateFormatter.supabaseIso.date(from: endTimeString) {
                endTime = endDate
            } else {
                throw DecodingError.dataCorruptedError(forKey: .endTime, in: container, debugDescription: "Invalid date format: \(endTimeString)")
            }
        } else {
            endTime = nil
        }

        // Decode pieceId, movementId, userId
        pieceId = try container.decodeIfPresent(UUID.self, forKey: .pieceId) ?? UUID()
        movementId = try container.decodeIfPresent(Int.self, forKey: .movementId)
        userId = try container.decodeIfPresent(UUID.self, forKey: .userId)
    }

    // Codable encode method
    func encode(to encoder: Encoder) throws {
            let dateFormatter = DateFormatter.supabaseIso
            var container = encoder.container(keyedBy: CodingKeys.self)
            let startTimeString = dateFormatter.string(from: startTime)
            try container.encode(startTimeString, forKey: .startTime)
            if let endTime = endTime {
                let endTimeString = dateFormatter.string(from: endTime)
                try container.encode(endTimeString, forKey: .endTime)
            }

            try container.encode(id, forKey: .id)
            try container.encodeIfPresent(piece?.id, forKey: .pieceId)
            try container.encodeIfPresent(movement?.id, forKey: .movementId)
        }

    static func == (lhs: PracticeSession, rhs: PracticeSession) -> Bool {
        return lhs.id == rhs.id
    }

}

struct PracticeSessionResponse: Decodable {
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
