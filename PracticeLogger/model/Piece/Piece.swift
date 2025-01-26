//
//  Piece.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/4/24.
//

import ApolloGQL
import MusicKit
import SwiftUI

class Piece: ObservableObject, Identifiable, Hashable, Codable {
    var id: Int
    @Published var workName: String
    var composer: Composer?
    @Published var movements: [Movement]
    @Published var catalogue_type: CatalogueType?
    @Published var catalogue_number: Int?
    @Published var nickname: String?
    var format: Format?
    var key_signature: KeySignatureType?

    init(
        id: Int = .random(in: 1 ... 10000),
        workName: String,
        composer: Composer,
        movements: [Movement]?,
        formattedKeySignature: String? = nil,
        catalogue_type: CatalogueType? = nil,
        catalogue_number: Int? = nil,
        format: Format? = nil,
        nickname: String? = nil,
        key_signature: KeySignatureType? = nil
    ) {
        self.id = id
        self.workName = workName
        self.composer = composer
        self.movements = movements ?? []
        self.format = format
        self.key_signature = key_signature
        self.catalogue_type = catalogue_type
        self.catalogue_number = catalogue_number
    }

    enum CodingKeys: String, CodingKey {
        case id
        case workName = "work_name"
        case nickname
        case movements
        case composer_id
        case composer
        case catalogue_type
        case catalogue_number
        case format
        case key_signature
        case tonality
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(workName, forKey: .workName)
        try container.encodeIfPresent(composer?.id, forKey: .composer_id)
//        try container.encodeIfPresent(catalogue_type, forKey: .catalogue_type)
        try container.encodeIfPresent(nickname, forKey: .nickname)
        try container.encodeIfPresent(catalogue_number, forKey: .catalogue_number)
        try container.encodeIfPresent(format, forKey: .format)
//        try container.encodeIfPresent(key_signature, forKey: .key_signature)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        workName = try container.decode(String.self, forKey: .workName)
        composer = nil
        movements = []
//        catalogue_type = try container.decodeIfPresent(CatalogueType.self, forKey: .catalogue_type)
        catalogue_number = try container.decodeIfPresent(Int.self, forKey: .catalogue_number)
        format = try container.decodeIfPresent(Format.self, forKey: .format)
//        key_signature = try container.decodeIfPresent(KeySignatureType.self, forKey: .key_signature)
        nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(workName)
        //        hasher.combine(composer)
        //        hasher.combine(movements)
        hasher.combine(catalogue_type)
        hasher.combine(catalogue_number)
        hasher.combine(format)
        hasher.combine(nickname)
        hasher.combine(key_signature)
    }

    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return
            lhs.catalogue_type == rhs.catalogue_type &&
            lhs.catalogue_number == rhs.catalogue_number
    }
}

// extension Piece {
//    func toGraphQLInput() -> PiecesInsertInput {
//        return PiecesInsertInput(
//            workName: .some(workName),
//            composerId: composer?.id != nil ? .some(BigInt(composer!.id)) : .null,
//            nickname: nickname != nil ? .some(nickname!) : .null,
//            format: format != nil ? .some(GraphQLEnum(format!.rawValue)) : .null,
//            keySignature: key_signature != nil ? .some(GraphQLEnum(key_signature!.rawValue.lowercased())) : .null,
//            catalogueType: catalogue_type != nil ? .some(GraphQLEnum(catalogue_type!.rawValue)) : .null,
//            catalogueNumber: catalogue_number != nil ? .some(catalogue_number!) : .null
//        )
//    }
// }
