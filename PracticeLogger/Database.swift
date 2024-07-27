//
//  Supabase.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import Foundation
import Supabase

class Database: ObservableObject {
    static let client: SupabaseClient = {
        guard let supabaseUrlString = Bundle.main.infoDictionary?["SUPABASE_URL"] as? String,
              let supabaseUrl = URL(string: supabaseUrlString),
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String
        else {
            fatalError("Missing SUPABASE_URL or SUPABASE_KEY in Info.plist")
        }

        return SupabaseClient(
            supabaseURL: supabaseUrl,
            supabaseKey: supabaseKey,
            options: SupabaseClientOptions(
                //                db: .init(encoder: encoder, decoder: decoder),
//                global: SupabaseClientOptions.GlobalOptions(logger: LogStore.shared)
            )
        )
    }()

    @Published var isLoggedIn: Bool = false

    static func getCurrentUser() throws -> User? {
        return Database.client.auth.currentUser
    }
}

struct SupabasePieceResponse: Codable {
    let id: UUID
    let workName: String
    let composerId: Int?
    let userId: UUID
    let format: String?
    let keySignature: String?
    let tonality: String?
    let catalogueType: String?
    let catalogueNumber: Int?
    let updatedAt: String?
    let createdAt: String?
    let nickname: String?
    let name: String?
    let number: Int?
    let movements: [MovementResponse]
    let composer: ComposerResponse

    enum CodingKeys: String, CodingKey {
        case id
        case workName = "work_name"
        case composerId = "composer_id"
        case userId = "user_id"
        case format
        case keySignature = "key_signature"
        case tonality
        case catalogueType = "catalogue_type"
        case catalogueNumber = "catalogue_number"
        case updatedAt = "updated_at"
        case createdAt = "created_at"
        case nickname
        case name
        case number
        case movements
        case composer
    }
}

struct MovementResponse: Codable {
    let id: Int
    let name: String?
    let number: Int
    let pieceId: UUID

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case number
        case pieceId = "piece_id"
    }
}

struct ComposerResponse: Codable {
    let id: Int
    let name: String
}
