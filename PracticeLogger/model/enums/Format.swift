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
}
