//
//  Piece.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/4/24.
//

import SwiftUI
import MusicKit

struct Movement: Identifiable {
    var id = UUID()
    var name: String
    var number: Int
    var selected: Bool = false
}

struct Composer: Identifiable {
    var name: String
    var id = UUID()
}

struct Piece: Identifiable {
    var id = UUID()
    var workName: String
    var composer: Composer
    var movements: [Movement]
    
    
    static func searchPiece(query: String) async throws -> Piece {
        let result = try await MusicCatalogSearchRequest(term: query, types: [Album.self]).response()
        let album = result.albums.first
        guard let album = result.albums.first else {
            // Throw an error or return a default value
            throw SearchError.noAlbum
        }
        
        let withTracks = try await album.with(.tracks)
        let workName = withTracks.tracks?.first?.workName
        let groupedTracks = withTracks.tracks?.filter {$0.workName == workName}
        let matchingSongs = groupedTracks?.compactMap { track -> Song? in
            guard case .song(let song) = track else { return nil }
            return song
        }
        
        return Piece(workName: matchingSongs?.first?.workName ?? "", composer: Composer(name: matchingSongs?.first?.composerName ?? ""),
                         movements: matchingSongs?.map { song in
            Movement(name: song.movementName ?? "", number: song.movementNumber ?? 0, selected: false)
        } ?? [])
        
    }
}

enum SearchError: Error {
    case noAlbum
}
