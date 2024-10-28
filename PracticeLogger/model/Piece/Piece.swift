//
//  Piece.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/4/24.
//

import ApolloGQL
import MusicKit
import SwiftUI

class Piece: ObservableObject, Identifiable, Hashable, Codable {
    var id: Int
    @Published var workName: String
    var composer: Composer?
    @Published var movements: [Movement]
    @Published var catalogue_type: CatalogueType?
    @Published var catalogue_number: Int?
    @Published var nickname: String?
    var format: Format?
    var key_signature: KeySignatureType?
    var tonality: KeySignatureTonality?

    init(
        id: Int = .random(in: 1 ... 10000),
        workName: String,
        composer: Composer,
        movements: [Movement]?,
        formattedKeySignature: String? = nil,
        catalogue_type: CatalogueType? = nil,
        catalogue_number: Int? = nil,
        format: Format? = nil,
        nickname: String? = nil,
        tonality: KeySignatureTonality? = nil,
        key_signature: KeySignatureType? = nil
    ) {
        self.id = id
        self.workName = workName
        self.composer = composer
        self.movements = movements ?? []
        self.format = format
        self.tonality = tonality
        self.key_signature = key_signature
        self.catalogue_type = catalogue_type
        self.catalogue_number = catalogue_number
    }

    enum CodingKeys: String, CodingKey {
        case id
        case workName = "work_name"
        case nickname
        case movements
        case composer_id
        case composer
        case catalogue_type
        case catalogue_number
        case format
        case key_signature
        case tonality
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(workName, forKey: .workName)
        try container.encodeIfPresent(composer?.id, forKey: .composer_id)
        try container.encodeIfPresent(catalogue_type, forKey: .catalogue_type)
        try container.encodeIfPresent(nickname, forKey: .nickname)
        try container.encodeIfPresent(catalogue_number, forKey: .catalogue_number)
        try container.encodeIfPresent(format, forKey: .format)
        try container.encodeIfPresent(key_signature, forKey: .key_signature)
        try container.encodeIfPresent(tonality, forKey: .tonality)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        workName = try container.decode(String.self, forKey: .workName)
        composer = nil
        movements = []
        catalogue_type = try container.decodeIfPresent(CatalogueType.self, forKey: .catalogue_type)
        catalogue_number = try container.decodeIfPresent(Int.self, forKey: .catalogue_number)
        format = try container.decodeIfPresent(Format.self, forKey: .format)
        key_signature = try container.decodeIfPresent(KeySignatureType.self, forKey: .key_signature)
        tonality = try container.decodeIfPresent(KeySignatureTonality.self, forKey: .tonality)
        nickname = try container.decodeIfPresent(String.self, forKey: .nickname)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(workName)
//        hasher.combine(composer)
//        hasher.combine(movements)
        hasher.combine(catalogue_type)
        hasher.combine(catalogue_number)
        hasher.combine(format)
        hasher.combine(nickname)
        hasher.combine(tonality)
        hasher.combine(key_signature)
    }

    static func == (lhs: Piece, rhs: Piece) -> Bool {
        return
            lhs.catalogue_type == rhs.catalogue_type &&
            lhs.catalogue_number == rhs.catalogue_number
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
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
            if let match = regex?.firstMatch(in: trackTitle, options: [], range: NSRange(location: 0, length: trackTitle.utf16.count)) {
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
                let movement = Movement(name: movementName.formatMovementName(), number: movementNumber)
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

    static func chooseBestRecords(uniqWorks: [String: Song]) -> [String: Song] {
        var workInfoGroupedByCatalogNumber: [String: [(String, Int)]] = [:]
        var result: [String: Song] = [:]
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

    static func addMetadata(_ piece: Piece) async -> Piece? {
        do {
            if let response: MetadataInformation = try await Database.client.rpc("parse_piece_metadata", params: ["work_name": piece.workName]).select().single().execute().value {
                dump(piece)
                return Piece(
                    workName: piece.workName,
                    composer: Composer(name: piece.composer?.name ?? ""),
                    movements: piece.movements,
                    catalogue_type: response.catalogue_type,
                    catalogue_number: response.catalogue_number,
                    format: response.format,
                    nickname: response.nickname,
                    tonality: response.tonality,
                    key_signature: response.key_signature
                )
            }
        } catch {
            print("Error getting piece metadata:", error)
            return nil
        }
        return nil
    }

    static func searchPieceFromSongName(query: String) async throws -> [Piece] {
        var pieces: [Piece] = []
        var uniqWorks: [String: Song] = [:]
        var result = MusicCatalogSearchRequest(term: query, types: [Song.self])

        result.limit = 25
        result.includeTopResults = true
        let response = try await result.response()

        for song in response.songs {
            if song.workName != nil && !uniqWorks.keys.contains(song.workName!) && songMatchesQuery(query: query, song: song) {
                uniqWorks[song.workName!] = song
            }
        }

        print("uniqWork count \(uniqWorks.count)")
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
                    }
                }
            }
        }
        uniqWorks = chooseBestRecords(uniqWorks: uniqWorks)

        for (_, song) in uniqWorks {
            var piece = try await createPieceFromSong(song: song)
            piece = await addMetadata(piece)!
            pieces.append(piece)
        }
        print("pieces count \(pieces.count)")

        return pieces
    }

    /**
     Checks Composer, Key Signature, and Cataloging information (opus/K/BWV) Information to determine if the piece matches with an 80% confidence score
     */
    static func songMatchesQuery(query: String, song: Song?) -> Bool {
        guard let song = song else {
            return false
        }

        let splitQuery = query.split(separator: " ")
        let matchingWeight = 10
        var total = splitQuery.count
        var matching = 0

        // Check if composer name matches
        if query.containsComposerName() {
            // Ensure song has a composer name and that it matches the query
            if let composerName = song.composerName {
                // Check if any part of the query is contained in the composer name
                if splitQuery.contains(where: { composerName.localizedCaseInsensitiveContains($0) }) {
                    matching += matchingWeight
                } else {
                    // composer does not match
                    return false
                }
            } else {
                return false
            }
            total += matchingWeight
        }

        // Check if work name matches
        if let workName = song.workName {
            if query.containsKeySignature() {
                if isMatchingKeySignature(query: query, workName: workName) {
                    matching += matchingWeight
                }
                total += matchingWeight
            }
            for word in splitQuery where query.contains(word) {
                if String(word).isNumber() {
                    matching += matchingWeight
                } else {
                    matching += 1
                }
            }
        }

        let confidence = Double(matching) / Double(total)
        print(song.workName ?? "", confidence)

        return confidence >= 0.90
    }

    static func createPieceFromSong(song: Song) async throws -> Piece {
        let workName = song.workName
        let songAlbum = try await song.with(.albums)
        let withTracks = try await songAlbum.albums?.first?.with(.tracks)
        let groupedTracks = withTracks?.tracks?.filter { $0.workName == workName }
        let matchingSongs = groupedTracks?.compactMap { track -> Song? in
            guard case .song(let song) = track else { return nil }
            return song
        }

        return Piece(workName: matchingSongs?.first?.workName ?? "",
                     composer: Composer(name: matchingSongs?.first?.composerName ?? ""),
                     movements: matchingSongs?.map { song in
                         Movement(name: song.movementName ?? "", number: song.movementNumber ?? 0)
                     } ?? [], formattedKeySignature: workName!.parseKeySignature().formatKeySignature() ?? nil)
    }

    static func isMatchingKeySignature(query: String, workName: String) -> Bool {
        let queryCheck = query.parseKeySignature()
        let workNameCheck = workName.parseKeySignature()
        return queryCheck == workNameCheck
    }

    static func extractCatalogNumber(from string: String) -> String? {
        // Define regular expression patterns for different cataloguing types
        let opPattern = #"Op\. (\d+)"# // For Op. numbers
        let kPattern = #"K\. (\d+)"# // For K. numbers (Mozart)
        let bwvPattern = #"BWV (\d+)"# // For BWV numbers (Bach)
        let dPattern = #"D (\d+)"# // For D numbers (Schubert)

        // Attempt to match each pattern in the input string
        let patterns = [opPattern, kPattern, bwvPattern, dPattern]
        for pattern in patterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: []) {
                if let match = regex.firstMatch(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count)) {
                    let range = Range(match.range(at: 1), in: string)!
                    return String(string[range])
                }
            }
        }
        return nil
    }
}

extension Piece {
    func toGraphQLInput() -> PiecesInsertInput {
        return PiecesInsertInput(
            workName: .some(workName),
            composerId: composer?.id != nil ? .some(BigInt(composer!.id)) : .null,
            format: format != nil ? .some(GraphQLEnum(format!.rawValue)) : .null,

            keySignature: key_signature != nil ? .some(GraphQLEnum(key_signature!.rawValue)) : .null,

            tonality: tonality != nil ? .some(GraphQLEnum(tonality!.rawValue.lowercased())) : .null, // TODO: make this consistent
            catalogueType: catalogue_type != nil ? .some(GraphQLEnum(catalogue_type!.rawValue)) : .null,
            catalogueNumber: catalogue_number != nil ? .some(catalogue_number!) : .null,
            nickname: nickname != nil ? .some(nickname!) : .null
        )
    }
}
