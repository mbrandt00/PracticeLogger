//
//  CreatePieceViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/4/24.
//

import Combine
import Foundation
import MusicKit

class CreatePieceViewModel: ObservableObject {
    @Published var pieces: [Piece] = []
    @Published var searchTerm: String = ""
    @Published var userPieces: [Piece] = []

    private var cancellables: Set<AnyCancellable> = []

    func getClassicalPieces(_ query: String, keySignatureToken: KeySignatureToken?) async {
        if query.isEmpty { return }
        do {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let fetchedPieces = try await Piece.searchPieceFromSongName(query: query, keySignatureToken: keySignatureToken)
                    DispatchQueue.main.async {
                        self.pieces = fetchedPieces
                    }
                } catch {
                    print("Error fetching pieces: \(error)")
                }
            case .denied:
                print("Denied")
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            default:
                print("Something happened")
            }
        }
    }

    func getRecentUserPracticeSessions() async throws -> [PracticeSession] {
        do {
            let userID = try Database.getCurrentUser()?.id

            let response: [PracticeSession] = try await Database.client
                .from("user_unique_piece_sessions_v")
                .select("*")
                .eq("user_id", value: userID)
                .order("end_time", ascending: false)
                .execute()
                .value
            dump(response)
            var sessions: [PracticeSession] = []

            for practiceSession in response {
                let convertedSession = try await PracticeSessionViewModel().createFullPracticeSessionResponse(practiceSession)
                sessions.append(convertedSession)
            }

            return sessions

        } catch {
            print("Error retrieving session: \(error)")
            return []
        }
    }

    func getUserPieces() async throws -> [Piece] {
        let response: [SupabasePieceResponse] = try await Database.client
            .from("pieces")
            .select("*, movements!inner(*), composer:composers!inner(id, name)")
            .eq("user_id", value: Database.getCurrentUser()?.id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value
        let pieces = mapResponseToFullPiece(response: response)

        DispatchQueue.main.async {
            self.userPieces = pieces
        }

        return pieces
    }
}
