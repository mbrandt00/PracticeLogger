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

    static var allCases: [KeySignatureTonality] {
        return [.major, .minor]
    }

    static func fromNormalizedString(_ string: String) -> KeySignatureTonality? {
        let normalizedString = normalizeString(string)
        return KeySignatureTonality.allCases.first { tonality in
            let tonalityString = normalizeString(tonality.rawValue)
            return tonalityString == normalizedString
        }
    }

    static func normalizeString(_ string: String) -> String {
        return string.lowercased().replacingOccurrences(of: " ", with: "")
    }
}
