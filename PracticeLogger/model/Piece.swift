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
    var appleMusicId: MusicItemID?
}

struct Composer: Identifiable {
    var name: String
    var id = UUID()
}

struct Piece: Identifiable, Hashable, Equatable {
    var id = UUID()
    var workName: String
    var composer: Composer
    var movements: [Movement]
    var formattedKeySignature: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    static func ==(lhs: Piece, rhs: Piece) -> Bool {
        return lhs.workName == rhs.workName && lhs.movements.count == lhs.movements.count
    }
    static func searchPieceFromSongName(query: String)  async throws -> [Piece] {
        var pieces: [Piece] = []
        var uniqWorks: [String: Song] = [:]
        var result = MusicCatalogSearchRequest(term: query, types: [Song.self])

        result.limit = 25
        result.includeTopResults = true
        let response = try await result.response()

        response.songs.forEach { song in
            if song.workName != nil && !uniqWorks.keys.contains(song.workName!) && songMatchesQuery(query: query, song: song) {                uniqWorks[song.workName!] = song
            }
        }

        if uniqWorks.isEmpty && !response.songs.isEmpty {
            print("Work names not found, but songs were")

            if let firstSong = response.songs.first {
                do {
                    let detailedSong = try await firstSong.with([.albums])
                    if let album = detailedSong.albums?.first {

                        // Use guard statement instead of conditional binding
                        if let albumTrack = try? await album.with([.tracks]) {
                            if let allAlbumTracks = albumTrack.tracks {
                                return try await createPiecesFromTrack(tracks: Array(allAlbumTracks))
                            }
                        }

                        // Continue with the rest of the code here...
                    }
                }
            }
        }

        uniqWorks = chooseBestRecords(uniqWorks: uniqWorks)

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
        let splitQuery = query.split(separator: " ")
        let matchingWeight = 10
        var total = splitQuery.count
        var matching = 0
        if let workName = song.workName {
            if query.containsKeySignature() {
                if isMatchingKeySignature(query: query, workName: workName) {
                    matching += matchingWeight
                }
                total += matchingWeight
            }
            for word in splitQuery {
                if query.contains(word) {
                    if String(word).isNumber() {
                        matching += matchingWeight
                    } else {
                        matching += 1
                    }
                }
            }
        }
        let confidence = Double(matching) / Double(total)
        print(song?.workName ?? "", confidence)

        return confidence >= 0.75
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
        } ?? [], formattedKeySignature: workName!.parseKeySignature().formatKeySignature() ?? nil)
    }

    static func isMatchingKeySignature(query: String, workName: String) -> Bool {
        let queryCheck = query.parseKeySignature()
        let workNameCheck = workName.parseKeySignature()
        return queryCheck == workNameCheck
    }

    static func extractCatalogNumber(from string: String) -> String? {
        // Define regular expression patterns for different cataloguing types
        let opPattern = #"Op\. (\d+)"#  // For Op. numbers
        let kPattern = #"K\. (\d+)"#    // For K. numbers (Mozart)
        let bwvPattern = #"BWV (\d+)"#  // For BWV numbers (Bach)
        let dPattern = #"D (\d+)"#      // For D numbers (Schubert)

        // Attempt to match each pattern in the input string
        let patterns = [opPattern, kPattern, bwvPattern, dPattern]
        for pattern in patterns {
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            if let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) {
                let range = Range(match.range(at: 1), in: string)!
                return String(string[range])
            }
        }
        return nil
    }
    
    func submitPiece () async{
        print("Submitted")
    }

    static func createPiecesFromTrack(tracks: [Track]) async throws -> [Piece] {
        var pieces: [Piece] = []
        var currentPieceName: String?
        var currentPieceMovements: [Movement] = []
        var movementNumber = 1
        func extractPieceInfo(from trackTitle: String) -> (String, String)? {
            // Define a pattern to extract the piece name and movement name
            let pattern = #"^(.+?):\s*(.+)$"# // Match everything until the first colon followed by everything after the colon and optional space

            // Attempt to match the pattern in the track title
            let regex = try! NSRegularExpression(pattern: pattern, options: [])
            if let match = regex.firstMatch(in: trackTitle, options: [], range: NSRange(location: 0, length: trackTitle.utf16.count)) {
                let pieceRange = Range(match.range(at: 1), in: trackTitle)!
                let movementRange = Range(match.range(at: 2), in: trackTitle)!
                let pieceName = String(trackTitle[pieceRange])
                let movementName = String(trackTitle[movementRange])
                return (pieceName, movementName)
            }

            return nil
        }
        for track in tracks {
            // Extract piece name and movement name from track title
            if let (pieceName, movementName) = extractPieceInfo(from: track.title) {
                // Continue with your existing logic
                guard case .song(let song) = track else { continue }
                let composerName = song.composerName ?? ""
                let appleMusicId = song.id

                // If the piece name changes, create a new piece
                if let currentName = currentPieceName, currentName != pieceName {
                    // Append the current piece to pieces array before creating a new one
                    if !currentPieceMovements.isEmpty {
                        let composer = Composer(name: composerName)
                        let piece = Piece(workName: currentName,
                                          composer: composer,
                                          movements: currentPieceMovements)
                        pieces.append(piece)
                    }
                    // Reset movement number for the new piece
                    movementNumber = 1
                    currentPieceMovements = []
                }

                // Update current piece name and append movement
                currentPieceName = pieceName
                let movement = Movement(name: movementName.formatMovementName(), number: movementNumber, appleMusicId: appleMusicId)
                currentPieceMovements.append(movement)
                movementNumber += 1 // Increment movement number for the next movement
            }
        }

        // Append the last piece to the pieces array
        if let currentName = currentPieceName {
            let composer = Composer(name: "") // Provide appropriate composer name
            let piece = Piece(workName: currentName,
                              composer: composer,
                              movements: currentPieceMovements)
            pieces.append(piece)
        }

        return pieces
    }

    func workNameWithoutKeySignature() -> String {
        let keyCharacters: Set<Character> = ["A", "B", "C", "D", "E", "F", "G"]
        let tonalities = ["Major", "Minor"]
        let accidentals = ["Flat", "Sharp", "♯", "♭", "#", "b" ]
        let words = workName.split(separator: " ")

        let filteredWords = words.filter { word in
            !keyCharacters.contains(word.first ?? Character("")) &&
            !tonalities.contains(String(word)) &&
            !accidentals.contains(String(word)) &&
            word.lowercased() != "in"
        }

        return filteredWords.joined(separator: " ")

    }

    static func chooseBestRecords(uniqWorks: [String: Song]) -> [String: Song] {
        var workInfoGroupedByCatalogNumber: [String: [(String, Int)]] = [:]
        var result: [String: Song] = [:]
        print(result)
        // Group work names by catalog number along with their movement counts
        for (workName, song) in uniqWorks {
            // Extract catalog number from the work name
            if let catalogNumber = extractCatalogNumber(from: workName) {
                // Check if the workName contains "Live" or parentheses
                if !workName.contains("Live") && !workName.contains("(") {
                    // Append the work name and movement count to the array corresponding to its catalog number
                    let workInfoTuple = (workName, song.movementCount ?? 0)
                    if var workInfoWithCatalogNumber = workInfoGroupedByCatalogNumber[catalogNumber] {
                        workInfoWithCatalogNumber.append(workInfoTuple)
                        workInfoGroupedByCatalogNumber[catalogNumber] = workInfoWithCatalogNumber
                    } else {
                        workInfoGroupedByCatalogNumber[catalogNumber] = [workInfoTuple]
                    }
                }
            } else {
                print("No catalog matches...")

            }
        }

        // Select the record with the maximum movement count for each catalog number
        for (_, workInfo) in workInfoGroupedByCatalogNumber {
            // Find the maximum movement count
            if let maxMovementCount = workInfo.max(by: { $0.1 < $1.1 })?.1 {
                // Find the record with the maximum movement count
                if let bestRecord = workInfo.first(where: { $0.1 == maxMovementCount }) {
                    // Retrieve the corresponding song object from uniqWorks
                    if let bestSong = uniqWorks[bestRecord.0] {
                        // Add the best record to the result dictionary
                        result[bestRecord.0] = bestSong
                    }
                }
            }
        }

        return result
    }
}
