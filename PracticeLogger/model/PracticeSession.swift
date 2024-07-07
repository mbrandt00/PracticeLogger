//
//  PracticeSession.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import Foundation

class PracticeSession: ObservableObject, Identifiable, Codable {
    let id: UUID
    @Published var start_time: Date
    @Published var end_time: Date?
    @Published var piece: Piece? // Piece object
    @Published var composer: Composer?
    var pieceId: UUID? // ID to fetch Piece
    @Published var movement: Movement?

    enum CodingKeys: String, CodingKey {
        case id
        case start_time
        case end_time
        case pieceId = "piece_id"
        case movementId = "movement_id"
        case userId = "user_id"
    }

    // Initialize PracticeSession from decoder
    init(start_time: Date, piece: Piece) {
        self.id = UUID()
        self.start_time = start_time
        self.piece = piece
        self.pieceId = piece.id // Assuming piece has an id
        self.end_time = nil
        self.movement = nil
    }
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        start_time = try container.decode(Date.self, forKey: .start_time)
        end_time = try container.decodeIfPresent(Date.self, forKey: .end_time)
        pieceId = try container.decodeIfPresent(UUID.self, forKey: .pieceId)
        movement = try container.decodeIfPresent(Movement.self, forKey: .movementId)
        piece = nil // Initialize piece as nil
        composer = nil

        // Fetch piece if pieceId is present
        if let p_id = pieceId {
            Task {
                do {
                    let fetchedPiece: Piece = try await Database.client.from("pieces")
                        .select("*, movements(*)")
                        .match(["id": p_id])
                        .single()
                        .execute()
                        .value
                    DispatchQueue.main.async {
                        self.assignFetchedPiece(fetchedPiece)
                    }
                } catch {
                    print("Error fetching associated Piece: \(error)")
                    // Handle error as needed
                }
            }
        }
    }

    private func assignFetchedPiece(_ fetchedPiece: Piece) {
        // Mutate self.piece inside a main queue async block
        self.piece = fetchedPiece
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(start_time, forKey: .start_time)
        try container.encodeIfPresent(end_time, forKey: .end_time)
        try container.encodeIfPresent(pieceId, forKey: .pieceId)
        try container.encodeIfPresent(movement, forKey: .movementId)
    }
}
