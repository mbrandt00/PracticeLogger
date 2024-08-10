//
//  Format.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Foundation

enum Format: String, Decodable, Encodable, CaseIterable, Identifiable, Hashable {
    case bagatelle = "Bagatelle"
    case ballade = "Ballade"
    case canon = "Canon"
    case caprice = "Caprice"
    case chorale = "Chorale"
    case concerto = "Concerto"
    case dance = "Dance"
    case etude = "Etude"
    case fantasy = "Fantasy"
    case fugue = "Fugue"
    case gavotte = "Gavotte"
    case gigue = "Gigue"
    case impromptu = "Impromptu"
    case intermezzo = "Intermezzo"
    case lied = "Lied"
    case march = "March"
    case mazurka = "Mazurka"
    case mass = "Mass"
    case minuet = "Minuet"
    case nocturne = "Nocturne"
    case overture = "Overture"
    case opera = "Opera"
    case oratorio = "Oratorio"
    case pastiche = "Pastiche"
    case prelude = "Prelude"
    case polonaise = "Polonaise"
    case rhapsody = "Rhapsody"
    case requiem = "Requiem"
    case rondo = "Rondo"
    case sarabande = "Sarabande"
    case scherzo = "Scherzo"
    case serenade = "Serenade"
    case sonata = "Sonata"
    case stringQuartet = "String Quartet"
    case suite = "Suite"
    case symphony = "Symphony"
    case tarantella = "Tarantella"
    case toccata = "Toccata"
    case variations = "Variations"
    case waltz = "Waltz"
    var id: Self { self }
}
