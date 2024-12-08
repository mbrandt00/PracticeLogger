////
////  Format.swift
////  PracticeLogger
////
////  Created by Michael Brandt on 7/30/24.
////
//
import Foundation
import ApolloGQL
import ApolloAPI
enum Format: String, Decodable, Encodable, CaseIterable, Identifiable, Hashable, ApolloAPI.EnumType{
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
// DELETE ME? 

extension PieceFormat {
    var displayName: String {
        switch self {
        case .bagatelle: return "Bagatelle"
        case .ballade: return "Ballade"
        case .canon: return "Canon"
        case .caprice: return "Caprice"
        case .chorale: return "Chorale"
        case .concerto: return "Concerto"
        case .dance: return "Dance"
        case .etude: return "Etude"
        case .fantasy: return "Fantasy"
        case .fugue: return "Fugue"
        case .gavotte: return "Gavotte"
        case .gigue: return "Gigue"
        case .impromptu: return "Impromptu"
        case .intermezzo: return "Intermezzo"
        case .lied: return "Lied"
        case .march: return "March"
        case .mazurka: return "Mazurka"
        case .mass: return "Mass"
        case .minuet: return "Minuet"
        case .nocturne: return "Nocturne"
        case .overture: return "Overture"
        case .opera: return "Opera"
        case .oratorio: return "Oratorio"
        case .pastiche: return "Pastiche"
        case .prelude: return "Prelude"
        case .polonaise: return "Polonaise"
        case .rhapsody: return "Rhapsody"
        case .requiem: return "Requiem"
        case .rondo: return "Rondo"
        case .sarabande: return "Sarabande"
        case .scherzo: return "Scherzo"
        case .seranade: return "Serenade"
        case .sonata: return "Sonata"
        case .stringQuartet: return "String Quartet"
        case .suite: return "Suite"
        case .symphony: return "Symphony"
        case .tarantella: return "Tarantella"
        case .toccata: return "Toccata"
        case .variations: return "Variations"
        case .waltz: return "Waltz"
        default:
            // Fallback: convert raw value by capitalizing first letter
            let formatted = self.rawValue.replacingOccurrences(of: "_", with: " ")
            return formatted.prefix(1).uppercased() + formatted.dropFirst()
        }
    }
}
