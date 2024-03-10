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
        Task {
            let result = try await Piece.searchPieceFromSongName(query: query)
            self.pieces = result
        }
        
    }
}
