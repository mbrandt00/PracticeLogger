//
//  KeySignatureType.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Foundation

enum KeySignatureType: String, Decodable, Encodable, CaseIterable, Identifiable {
    case C
    case Csharp = "C♯"
    case Cflat = "C♭"
    case D
    case Dsharp = "D♯"
    case Dflat = "D♭"
    case E
    case Esharp = "E♯"
    case Eflat = "E♭"
    case F
    case Fsharp = "F♯"
    case Fflat = "F♭"
    case G
    case Gsharp = "G♯"
    case Gflat = "G♭"
    case A
    case Asharp = "A♯"
    case Aflat = "A♭"
    case B
    case Bsharp = "B♯"
    case Bflat = "B♭"

    var id: Self { self }

    // Mapping for encoding
    private static let encodingMap: [KeySignatureType: String] = {
        var map = [KeySignatureType: String]()
        for keySignature in KeySignatureType.allCases {
            map[keySignature] = keySignature.rawValue
        }
        return map
    }()

    // Normalize string for decoding
    static func fromNormalizedString(_ string: String) -> KeySignatureType? {
        let normalizedString = normalizeString(string)
        return KeySignatureType.allCases.first { keySignature in
            let keySignatureString = normalizeString(keySignature.rawValue)
            return keySignatureString == normalizedString
        }
    }

    // Normalize string for comparison
    static func normalizeString(_ string: String) -> String {
        return string
            .lowercased()
            .replacingOccurrences(of: "sharp", with: "♯")
            .replacingOccurrences(of: "flat", with: "♭")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }

    // Override encode to ensure we encode in the correct format for PostgreSQL
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let encodedValue = KeySignatureType.encodingMap[self] {
            try container.encode(encodedValue)
        } else {
            throw EncodingError.invalidValue(self, EncodingError.Context(codingPath: container.codingPath, debugDescription: "Invalid KeySignatureType"))
        }
    }

    // Implement custom decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let keySignature = KeySignatureType.fromNormalizedString(rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid value for KeySignatureType: \(rawValue)")
        }
        self = keySignature
    }
}
