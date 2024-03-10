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
    
    static func searchPieceFromSongName(query: String)  async throws -> [Piece] {
        /*
         cleanse string try to get rid of
         These kinds of results
         - 4 : "Piano Concerto No. 4 in G Minor, Op. 40 (1941 3rd Version)"
         - 5 : "Piano Concerto No. 4 in G Minor, Op. 40 (Live at Kimmel Center, Philadelphia, PA, USA)"
         - 6 : "8 Etudes, Op. 42
         
         */
        var pieces: [Piece] = []
        var uniqWorks: [String: Song] = [:]
        var result = try await MusicCatalogSearchRequest(term: query, types: [Song.self])
        result.limit = 25
        result.includeTopResults = true
        let response = try await result.response()
        
        response.songs.forEach { song in
            if (song.workName != nil && !uniqWorks.keys.contains(song.workName!)) {
                uniqWorks[song.workName!] = song
            }
            
        }
        
        for (_, song) in uniqWorks {
            let piece = try await createPieceFromSong(song: song)
            pieces.append(piece)
        }
        return pieces
    }
    
    static func createPieceFromSong(song: Song) async throws -> Piece {
        
        let workName = song.workName
        let songAlbum = try await song.with(.albums)
        let withTracks = try await songAlbum.albums?.first?.with(.tracks)
        let groupedTracks = withTracks?.tracks?.filter {$0.workName == workName}
        let matchingSongs = groupedTracks?.compactMap { track -> Song? in
            guard case .song(let song) = track else { return nil }
            return song
        }
        
        return Piece(workName: matchingSongs?.first?.workName ?? "",
                     composer: Composer(name: matchingSongs?.first?.composerName ?? ""),
                     movements: matchingSongs?.map { song in
            Movement(name: song.movementName ?? "", number: song.movementNumber ?? 0, selected: false)
        } ?? [])
    }
}

enum SearchError: Error {
    case noAlbum
}
