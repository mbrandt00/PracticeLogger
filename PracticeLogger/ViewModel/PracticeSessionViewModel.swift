//
//  PracticeSessionViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import Foundation
import Supabase
class PracticeSessionViewModel: ObservableObject {
    @Published var session: PracticeSession?
    @Published var piece: Piece?

    func startSession(record: Record) async throws -> PracticeSession? {
        switch record {
            case .piece(let piece):
            print("Starting session with piece: \(piece)")
            do {
                let practice_session = PracticeSession(start_time: Date.now, piece: piece)

                let insertedPracticeSessions: PracticeSession = try await Database.client.from("practice_sessions")
                    .insert(practice_session)
                    .select()
                    .single()
                    .execute()
                    .value
                print(insertedPracticeSessions)
                return PracticeSession(start_time: Date.now, piece: piece)
            } catch let error as PostgrestError {
                print("INSERT ERROR", error)

                if error.message.contains("pieces_catalogue_unique") {
                    throw SupabaseError.pieceAlreadyExists
                }

            }
            case .movement(let movement):
                // Handle Movement
                print("Starting session with movement: \(movement)")
            
            }
        return nil
    }
}

enum Record {
    case piece(Piece)
    case movement(Movement)
}
