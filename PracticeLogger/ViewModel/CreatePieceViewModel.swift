//
//  CreatePieceViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/4/24.
//

import Foundation
import MusicKit

class CreatePieceViewModel: ObservableObject {
    @Published var pieces: [Piece] = []

    func getClassicalPieces(_ query: String) async {
        do {
            let fetchedPieces = try await Piece.searchPieceFromSongName(query: query)
            DispatchQueue.main.async {
                // Update UI or ViewModel state with fetched pieces
                self.pieces = fetchedPieces
            }
        } catch {
            // Handle error (e.g., display error message to the user)
            print("Error fetching pieces: \(error)")
        }
    }
}
