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
    
    func getClassicalPieces(_ query: String)  {
        Task {
            do {
                let result = try await MusicCatalogSearchRequest(term: query, types: [Song.self]).response()
                print(result)
                let classicalSongs = result.songs.filter { song in
                    if let genres = song.genres {
                        return genres.contains { genre in
                            genre.name == "Classical"
                        }
                    }
                    return false
                }
                //                DispatchQueue.main.async {
                //                    self.pieces = result.songs as? [Piece] ?? []
                //                }
            } catch {
                // Handle errors here
                print("Error: \(error)")
            }
        }
        
    }
}
