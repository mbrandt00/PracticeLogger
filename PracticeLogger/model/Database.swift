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
            let currentUser = try await getCurrentUser()
            let currentUserID = try await getCurrentUser().id.uuidString
            
            let insertedPiece: DbPiece = try await client.from("pieces")
                .insert([
                    "workName": piece.workName,
                    "userId": currentUserID
                ]).select().single().execute().value
            
            let newPieceId = insertedPiece.id
            for movement in piece.movements {
                print(movement)
                var dbMovement: DbPieceMovement = try await client
                    .from("movements")
                    .insert([
                        "movement_name": movement.name,
                        "movement_number": String(movement.number),
                        "piece_id": String(newPieceId)
                    ]).select().single().execute().value
                print("new db movement", dbMovement)
            }
            return insertedPiece
        } catch {
            throw error
        }
    }
}

struct DbPiece: Codable {
  let id: Int
  let work_name: String
  let user_id: UUID
}

struct DbPieceMovement: Codable {
  let id: Int
  let movement_name: String
  let movement_number: Int
  let piece_id: Int
}
