//
//  Structs.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import Foundation

struct Composer: Codable, Hashable, Identifiable {
    var firstName: String
    var id: Int
    var lastName: String
    var musicalEra: String
}
struct Piece: Hashable, Codable, Identifiable  {
    var id: Int
    var title: String
    var composer: Composer
}
struct Log: Hashable, Codable, Identifiable {
    var id = UUID()
    var minutes: Int
    var dateStart: Date
    var piece: Piece
}
