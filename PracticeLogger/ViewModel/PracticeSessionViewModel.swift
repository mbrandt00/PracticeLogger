//
//  PracticeSessionViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import Foundation
import Supabase
class PracticeSessionViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var loadingRecord: Record?

    func startSession(record: Record) async throws -> PracticeSession? {
        DispatchQueue.main.async {
            self.isLoading = true
            self.loadingRecord = record
        }

        defer {
            DispatchQueue.main.async {
                self.isLoading = false
                self.loadingRecord = nil
            }
        }

        switch record {
        case .piece(let piece):
            print("Starting session with piece: \(piece)")
            let practice_session = PracticeSession(start_time: Date.now, piece: piece)
            do {
                let insertedPracticeSession: PracticeSession = try await Database.client.from("practice_sessions")
                    .insert(practice_session)
                    .select()
                    .single()
                    .execute()
                    .value
                print("Inserted session:", insertedPracticeSession)
                return insertedPracticeSession
            } catch let error as PostgrestError {
                print("INSERT ERROR", error)
                if error.message.contains("pieces_catalogue_unique") {
                    throw SupabaseError.pieceAlreadyExists
                } else {
                    throw error // Rethrow other PostgrestErrors
                }
            }

        case .movement(let movement):
            print("Starting session with movement: \(movement)")
            let practice_session = PracticeSession(start_time: Date.now, movement: movement)
            do {
                let insertedPracticeSession: PracticeSession = try await Database.client.from("practice_sessions")
                    .insert(practice_session)
                    .select()
                    .single()
                    .execute()
                    .value
                print("Inserted session:", insertedPracticeSession)
                return insertedPracticeSession
            } catch let error as PostgrestError {
                print("INSERT ERROR", error)
                throw error // Rethrow PostgrestError for movements
            }
        }
    }
}

enum Record {
    case piece(Piece)
    case movement(Movement)
}
