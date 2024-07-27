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

    init() {
        $searchTerm
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { searchTerm in
                Task {
                    await self.getClassicalPieces(searchTerm)
                }
            }
            .store(in: &cancellables)
    }

    func getClassicalPieces(_ query: String) async {
        if query.isEmpty { return }
        do {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let fetchedPieces = try await Piece.searchPieceFromSongName(query: query)
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
