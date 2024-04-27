//
//  CreatePieceViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/4/24.
//

import Foundation
import MusicKit
import OSLog
let logger = Logger()
class CreatePieceViewModel: ObservableObject {
    @Published var pieces: [Piece] = []

    func getClassicalPieces(_ query: String) async {
        do {
            logger.info("Requesting music auth")
            let status = await MusicAuthorization.request()
            print(status)
            switch status {
            case .authorized:
                do {
                    let fetchedPieces = try await Piece.searchPieceFromSongName(query: query)
                    DispatchQueue.main.async {

                        self.pieces = fetchedPieces
                    }

                } catch {
                    logger.error("Error fetching pieces: Error")
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
}
