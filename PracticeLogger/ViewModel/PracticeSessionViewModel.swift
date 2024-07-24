//
//  PracticeSessionViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//
import Foundation
import Supabase

class PracticeSessionViewModel: ObservableObject {
    @Published var activeSession: PracticeSession?
    func startSession(record: Record) async throws -> PracticeSession? {
        switch record {
        case .piece(let piece):
            print("Starting session with piece: \(piece)")
            let practice_session = PracticeSession(start_time: Date.now, piece: piece)
            return try await insertPracticeSession(practice_session)

        case .movement(let movement):
            print("Starting session with movement: \(movement)")
            let practice_session = PracticeSession(start_time: Date.now, movement: movement)
            return try await insertPracticeSession(practice_session)
        }
    }

    func stopSession() async {
        print("IN STOP SESSION")
        do {
            _ = try await Database.client
                        .from("practice_sessions")
                        .update(["end_time": Date()])
                        .eq("id", value: activeSession?.pieceId)
                        .execute()
            DispatchQueue.main.async {
                self.activeSession = nil
            }
        } catch {
            print("Error updating end_time: \(error)")
        }
    }

    func fetchCurrentActiveSession() async -> PracticeSession? {
            do {
                let userID = try Database.getCurrentUser()?.id

                let response: PracticeSessionResponse = try await Database.client
                    .from("practice_sessions")
                    .select("*")
                    .eq("user_id", value: userID)
                    .is("end_time", value: nil)
                    .single()
                    .execute()
                    .value

                guard let pieceResponse: SupabasePieceResponse = try await Database.client
                    .from("pieces")
                    .select("*, movements!inner(*), composer:composers!inner(id, name)")
                    .eq("id", value: response.pieceId)
                    .single()
                    .execute()
                    .value else {
                        print("Could not convert Supabase response to piece object")
                        return nil
                }

                // Map piece response to your custom piece model
                let mappedPiece = mapResponseToFullPiece(response: pieceResponse)

                var practiceSession: PracticeSession
                if let movementId = response.movementId,
                   let selectedMovement = pieceResponse.movements.first(where: { $0.id == movementId }) {
                    practiceSession = PracticeSession(
                        start_time: response.startTime!,
                        movement: Movement(
                            id: selectedMovement.id,
                            name: selectedMovement.name ?? "",
                            number: selectedMovement.number,
                            piece: mappedPiece,
                            pieceId: selectedMovement.pieceId
                        ),
                        id: response.id
                    )
                } else {
                    practiceSession = PracticeSession(
                        start_time: response.startTime!,
                        piece: mappedPiece,
                        id: response.id
                    )
                }

                return practiceSession

            } catch {
                print("Error retrieving session: \(error)")
                return nil
            }
        }

    private func insertPracticeSession(_ practiceSession: PracticeSession) async throws -> PracticeSession {
        do {
            let insertedPracticeSession: PracticeSession = try await Database.client
                .from("practice_sessions")
                .insert(practiceSession)
                .select()
                .single()
                .execute()
                .value
            print("Inserted session:", insertedPracticeSession)
            DispatchQueue.main.async {
                self.activeSession = insertedPracticeSession
            }
            return insertedPracticeSession
        } catch let error {
            print("Practice Session not inserted \(error)")
            throw error
        }
    }
}

enum Record {
    case piece(Piece)
    case movement(Movement)
}
