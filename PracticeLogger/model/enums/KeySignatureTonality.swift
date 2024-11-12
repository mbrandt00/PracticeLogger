//
//  KeySignatureTonality.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Foundation

enum KeySignatureTonality: String, Decodable, Encodable, CaseIterable, Identifiable {
    case major = "Major"
    case minor = "Minor"

    var id: Self { self }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        let normalizedValue = KeySignatureTonality.normalizeString(rawValue)
        guard let match = KeySignatureTonality.fromNormalizedString(normalizedValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize KeySignatureTonality from invalid String value \(rawValue)")
        }
        self = match
    }

    static func fromNormalizedString(_ string: String) -> KeySignatureTonality? {
        let normalizedString = normalizeString(string)
        return KeySignatureTonality.allCases.first { normalizeString($0.rawValue) == normalizedString }
    }

    static func normalizeString(_ string: String) -> String {
        return string.lowercased().replacingOccurrences(of: " ", with: "")
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue.lowercased()) // Encode as lowercase
    }
}
