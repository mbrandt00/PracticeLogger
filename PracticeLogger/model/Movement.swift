//
//  Movement.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/17/24.
//

import Foundation
import MusicKit

class Movement: Identifiable, ObservableObject, Codable {
    let id: Int
    @Published var name: String
    var number: Int
    var selected: Bool
    var appleMusicId: MusicItemID?
    var piece: Piece?
    var pieceId: UUID?

    init(id: Int = Int.random(in: 1...Int.max), name: String, number: Int, selected: Bool = false, appleMusicId: MusicItemID? = nil, piece: Piece? = nil, pieceId: UUID? = nil) {
        self.id = id
        self.name = name
        self.number = number
        self.selected = selected
        self.appleMusicId = appleMusicId
        self.piece = piece
        self.pieceId = pieceId
    }

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case number
        case selected
        case appleMusicId = "apple_music_id"
        case pieceId = "piece_id"
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(number, forKey: .number)
        try container.encode(pieceId, forKey: .pieceId)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        number = try container.decode(Int.self, forKey: .number)
        selected = try container.decode(Bool.self, forKey: .selected)
        appleMusicId = try container.decodeIfPresent(MusicItemID.self, forKey: .appleMusicId)
        pieceId = try container.decodeIfPresent(UUID.self, forKey: .pieceId)
    }
}
