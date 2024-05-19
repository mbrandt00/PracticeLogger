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
              let supabaseKey = Bundle.main.infoDictionary?["SUPABASE_KEY"] as? String else {
            fatalError("Missing SUPABASE_URL or SUPABASE_KEY in Info.plist")
        }

        return SupabaseClient(supabaseURL: supabaseUrl, supabaseKey: supabaseKey)
    }()

    @Published var isLoggedIn: Bool = false

    static func getCurrentUser() async throws -> User {
        do {
            let user = try await client.auth.session.user
            return user
        } catch {
            // Handle any errors
            throw error
        }
    }

    static func createPiece(piece: Piece) async throws {
        // move this to PieceEditViewModel
        do {
//            let currentUserID = try await getCurrentUser().id.uuidString
            let composer: DbComposer = try await client
                .rpc("find_or_create_composer", params: ["name": piece.composer.name])
                .execute()
                .value

            piece.composer.id = composer.id
            dump(piece)
            let insertedPiece = try await client.from("pieces")
                .insert(piece)
                .execute()
//                .select().single().execute().value
//
//            let newPieceId = insertedPiece.id
//            // bulk create
//            for movement in piece.movements {
//                try await client
//                    .from("movements")
//                    .insert([
//                        "name": movement.name,
//                        "number": String(movement.number),
//                        "pieceid": String(newPieceId)
//                    ]).select().single().execute().value
//            }
//            return nil
//            return insertedPiece
        } catch let error as PostgrestError {
            print("INSERT ERROR", error)

            if error.message.contains("pieces_catalogue_unique") {
                throw SupabaseError.pieceAlreadyExists
            }

        }
    }
}

struct DbPieceMovement: Codable {
  let id: Int
  let name: String
  let number: Int
  let piece_id: Int?
}

struct DbComposer: Codable {
  let id: Int
  let name: String
}

// use as a when or as an inseret?
// how to make queries efficient in Database.swift?
