//
//  Format.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Foundation

enum Format: String, Decodable, Encodable, CaseIterable, Identifiable, Hashable {
    case bagatelle
    case ballade
    case canon
    case caprice
    case chorale
    case concerto
    case dance
    case etude
    case fantasy
    case fugue
    case gavotte
    case gigue
    case impromptu
    case intermezzo
    case lied
    case march
    case mazurka
    case mass
    case minuet
    case nocturne
    case overture
    case opera
    case oratorio
    case pastiche
    case prelude
    case polonaise
    case rhapsody
    case requiem
    case rondo
    case sarabande
    case scherzo
    case serenade
    case sonata
    case stringQuartet
    case suite
    case symphony
    case tarantella
    case toccata
    case variations
    case waltz

    var id: Self { self }

    // Custom Decoding to handle non-capitalized raw values
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let rawValue = try container.decode(String.self)
//
//        // Capitalize the first letter of the raw value
//        let normalizedValue = rawValue.prefix(1).capitalized + rawValue.dropFirst()
//
//        if let format = Format(rawValue: normalizedValue) {
//            self = format
//        } else {
//            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot initialize Format from invalid String value \(rawValue)")
//        }
//    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue.lowercased()) // Encode the raw value in lowercase
    }
}
