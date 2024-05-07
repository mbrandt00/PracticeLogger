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

    static func createPiece(piece: Piece) async throws -> DbPiece {
        do {
            let currentUserID = try await String(getCurrentUser().id.uuidString)
            let composer: DbComposer = try await client
                .rpc("find_or_create_composer", params: ["name": piece.composer.name])
                .execute()
                .value
            print(composer)

            let insertedPiece: DbPiece = try await client.from("pieces")
                .insert([
                    "workname": piece.workName,
                    "userid": currentUserID,
                    "composerid": String(composer.id)

                ]).select().single().execute().value
            print(insertedPiece)

            let newPieceId = insertedPiece.id
            for movement in piece.movements {
                print(movement)
                let dbMovement: DbPieceMovement = try await client
                    .from("movements")
                    .insert([
                        "name": movement.name,
                        "number": String(movement.number),
                        "pieceid": String(newPieceId)
                    ]).select().single().execute().value
                print("new db movement", dbMovement)
            }
            return insertedPiece
        } catch {
            print(error)
            throw error
        }
    }
}

struct DbPiece: Codable {
    let id: Int
    let workName: String?
    let userId: UUID?
    let composerId: Int?
}

struct DbPieceMovement: Codable {
  let id: Int
  let name: String
  let number: Int
  let pieceId: Int?
}

struct DbComposer: Codable {
  let id: Int
  let name: String
}
