//
//  CreatePieceViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/4/24.
//

import Foundation
import MusicKit
import Combine
import OSLog

let logger = Logger()

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
        do {
            logger.info("Requesting music auth")
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    let fetchedPieces = try await Piece.searchPieceFromSongName(query: query)
                    DispatchQueue.main.async {
                        self.pieces = fetchedPieces
                    }
                } catch {
                    logger.error("Error fetching pieces: \(error)")
                    print("Error fetching pieces: \(error)")
                }
            case .denied:
                logger.info("Denied")
            case .notDetermined:
                logger.info("Not Determined")
            case .restricted:
                logger.info("Restricted")
            default:
                logger.info("Something happened")
            }
        }
    }

    func getUserPieces() async throws -> [Piece] {

        let pieces: [Piece] = try await Database.client
            .from("pieces")
            .select("*, movements(*)")
            .eq("user_id", value: try Database.getCurrentUser().id)
            .order("created_at", ascending: false)
            .execute()
            .value

        DispatchQueue.main.async {
            self.userPieces = pieces
        }

        return pieces
    }
}
