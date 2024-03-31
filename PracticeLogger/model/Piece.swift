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
    
    static func searchPieceFromSongName(query: String)  async throws -> [Piece] {
        /*
         cleanse string try to get rid of
         These kinds of results
         - 4 : "Piano Concerto No. 4 in G Minor, Op. 40 (1941 3rd Version)"
         - 5 : "Piano Concerto No. 4 in G Minor, Op. 40 (Live at Kimmel Center, Philadelphia, PA, USA)"
         - 6 : "8 Etudes, Op. 42
         Currently returns Tchaikovsky Piano Concerto when searching Rachmaninoff Concerto
         
         */
        var pieces: [Piece] = []
        var uniqWorks: [String: Song] = [:]
        var result = MusicCatalogSearchRequest(term: query, types: [Song.self])
        result.limit = 25
        result.includeTopResults = true
        let response = try await result.response()
        response.songs.forEach { song in
            if song.workName != nil && !uniqWorks.keys.contains(song.workName!) && songMatchesQuery(query: query, song: song) && !song.workName!.contains("Live") && !song.workName!.contains("(")
            {                uniqWorks[song.workName!] = song
            }
        }
        
        for (_, song) in uniqWorks {
            let piece = try await createPieceFromSong(song: song)
            pieces.append(piece)
        }
        return pieces
    }
    
    /**
     Checks Composer, Key Signature, and Cataloging information (opus/K/BWV) Information to determine if the piece matches with an 80% confidence score
     */
    static func songMatchesQuery (query: String, song: Song!) -> Bool {
        // opus/BMV/K/HOB/, compose name key signature boosting...
        let splitQuery = query.split(separator: " ")
        var matchingKeySignatureWeight = 3
        var total = splitQuery.count
        var matching = 0
        if let workName = song.workName {
            if query.containsKeySignature(){
                if isMatchingKeySignature(query: query, workName: workName){
                    matchingKeySignatureWeight += 3
                }
                total += 3
            }
            for word in splitQuery {
                
                if query.contains(word) {
                    if String(word).isNumber() {
                        matching += 3
                    } else {
                        matching += 1
                    }
                }
            }
        }
        let confidence = Double(matching) / Double(total)
        //        print(song.workName, confidence)
        return confidence >= 0.85
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
    
    static func isMatchingKeySignature(query: String, workName: String) -> Bool {
        let queryCheck = parseKeySignature(string: query)
        let workNameCheck = parseKeySignature(string: workName)
        return queryCheck == workNameCheck
    }
    
    static func parseKeySignature(string: String!) -> Set<String> {
        // Optional("Piano Concerto No. 1 in B-Flat Minor, Op. 23") Dashes...
        let keyCharacters: Set<Character> = ["A", "B", "C", "D", "E", "F", "G"]
        let tonalities = ["major", "minor"]
        let accidentals = ["flat", "sharp", "♯", "♭", "#", "b" ]
        let words = string.split(separator: " ")
        var parsedQueryKeySignature: Set<String> = []
        if let startIndex = words.firstIndex(where: { word in
            keyCharacters.contains(word.first ?? Character(""))
        }) {
            // Start iterating from the index of the first word containing a key character
            for wordIndex in startIndex..<words.endIndex {
                var word = words[wordIndex].lowercased()
                if word.last == "," {
                    word.removeLast() // Remove the last character (which is the comma)
                }
                if word.contains("-") {
                    let parts = word.split(separator: "-")
                    for part in parts {
                        if keyCharacters.contains(part.first ?? Character("")) || accidentals.contains(String(part)) {
                            parsedQueryKeySignature.insert(String(part))
                            
                        }
                    }
                } else if tonalities.contains(String(word)) || keyCharacters.contains(String(word)) || accidentals.contains(String(word)){
                    parsedQueryKeySignature.insert(String(word))
                }
            }
        }
        return parsedQueryKeySignature
    }
    
}
