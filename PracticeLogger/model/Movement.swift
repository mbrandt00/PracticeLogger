//
//  Movement.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/17/24.
//

import Foundation
import MusicKit

class Movement: Identifiable, ObservableObject, Encodable {
    let id = Int()
    @Published var name: String
    var number: Int
    var selected: Bool = false
    var appleMusicId: MusicItemID?

    init(name: String, number: Int, selected: Bool = false, appleMusicId: MusicItemID? = nil) {
        self.name = name
        self.number = number
        self.appleMusicId = appleMusicId
    }

    // Define the keys used for encoding
    private enum CodingKeys: String, CodingKey {
        case name
        case number
        case selected
        case appleMusicId
    }

    // Implement the encode(to:) method to encode the properties
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(number, forKey: .number)
        try container.encode(selected, forKey: .selected)
        try container.encode(appleMusicId, forKey: .appleMusicId)
    }
}
