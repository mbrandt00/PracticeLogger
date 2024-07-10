//
//  PracticeSession.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import Foundation

class PracticeSession: ObservableObject, Identifiable, Codable {
    let id: UUID
    @Published var startTime: Date
    @Published var endTime: Date?
    @Published var piece: Piece? // Piece object
    @Published var composer: Composer?
    var pieceId: UUID // ID to fetch Piece
    var movementId: Int?
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
    init(start_time: Date, piece: Piece? = nil, movement: Movement? = nil) {
        self.id = UUID()
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
}
