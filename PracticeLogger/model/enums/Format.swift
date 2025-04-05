////
////  Format.swift
////  PracticeLogger
////
////  Created by Michael Brandt on 7/30/24.
////
//
import ApolloAPI
import ApolloGQL
import Foundation

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
        }
    }
}
