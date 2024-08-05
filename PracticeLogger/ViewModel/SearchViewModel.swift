//
//  SearchViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Combine
import Foundation
import MusicKit

class SearchViewModel: ObservableObject {
    @Published var searchTerm = ""
//        didSet {
//            if searchTerm.last == " " {
//                updateTokens()
//            }
//        }
    @Published var selectedKeySignature: KeySignatureType?
    @Published var searchResults: [Piece] = []

    @Published var tokens: [FilterToken] = []
//    @Published var suggestedTokens: [KeySignatureToken] = []
    private var cancellables = Set<AnyCancellable>()
//    func updateTokens() {
//        // Ensure the last character is a space
//        guard searchTerm.hasSuffix(" ") else {
//            return
//        }
//
//        // Define key signature patterns
//        let accidentals = ["sharp", "flat", "♯", "♭", "#", "b"]
//        let keys = ["a", "b", "c", "d", "e", "f", "g"]
//        let tonalities = ["major", "minor"]
//
//        // Split the search term into words
//        let words = searchTerm.lowercased().split(separator: " ").map { String($0) }
//        var keySignatureToken: KeySignatureToken?
//
//        // Identify and extract key signature
//        for i in 0 ..< words.count {
//            let word = words[i]
//
//            if keys.contains(word) || keySignatureToken != nil {
//                // Check if the next word is an accidental
//                if i + 1 < words.count, accidentals.contains(words[i + 1]) {
//                    let nextWord = words[i + 1]
//                    let accidental = nextWord == "sharp" || nextWord == "♯" || nextWord == "#" ? "♯" : "♭"
//                    let keySignature = "\(word)\(accidental)"
//                    let keyType = KeySignatureType.fromNormalizedString(keySignature)
//
//                    // Create or update the keySignatureToken
//                    keySignatureToken = KeySignatureToken(type: keyType, tonality: nil)
//
//                    // Update tokens array
//                    if let token = keySignatureToken {
//                        tokens = [token]
//                    }
//
//                    // Remove the key signature part from searchTerm
//                    let prefix = words.prefix(i).joined(separator: " ")
//                    let suffix = words.dropFirst(i + 2).joined(separator: " ")
//                    searchTerm = [prefix, suffix].joined(separator: " ").trimmingCharacters(in: .whitespaces)
//
//                    print("Remaining string: \(searchTerm)")
//                    print("Token: \(keySignatureToken!)")
//                    continue
//                } else {
//                    if i + 1 < words.count && !accidentals.contains(words[i + 1]) {
//                        let keySignature = word
//                        let keyType = KeySignatureType.fromNormalizedString(keySignature)
//
//                        // Create or update the keySignatureToken
//                        keySignatureToken = KeySignatureToken(type: keyType, tonality: nil)
//
//                        // Update tokens array
//                        if let token = keySignatureToken {
//                            tokens = [token]
//                        }
//
//                        // Remove the key signature part from searchTerm
//                        let prefix = words.prefix(i).joined(separator: " ")
//                        let suffix = words.dropFirst(i + 1).joined(separator: " ")
//                        searchTerm = [prefix, suffix].joined(separator: " ").trimmingCharacters(in: .whitespaces)
//
//                        print("Remaining string: \(searchTerm)")
//                        print("Token: \(keySignatureToken!)")
//                        continue
//                    }
//                }
//            }
//        }
//
//        // Process tonalities if a key signature token exists
//        for i in 0 ..< words.count {
//            let word = words[i]
//            if tonalities.contains(word) {
//                let tonality = KeySignatureTonality.fromNormalizedString(word)
//
//                if let existingToken = tokens.first {
//                    let type = existingToken.type
//                    let updatedToken = KeySignatureToken(type: type, tonality: tonality)
//                    tokens = [updatedToken]
//                }
//
//                // Update searchTerm to remove tonality
//                let prefix = words.prefix(i).joined(separator: " ")
//                let suffix = words.dropFirst(i + 1).joined(separator: " ")
//                searchTerm = [prefix, suffix].joined(separator: " ").trimmingCharacters(in: .whitespaces)
//
//                print("Remaining string: \(searchTerm)")
//            }
//        }
//    }

    func searchPieces() async {
        if searchTerm.isEmpty { return }
        do {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
                    var fetchedPieces = try await Piece.searchPieceFromSongName(query: searchTerm)
//                    if let token = tokens.first {
//                        fetchedPieces = fetchedPieces.filter { piece in
//                            piece.key_signature == token.type
//                        }
//                    }
                    let userPieces = try await getUserPieces()
                    DispatchQueue.main.async {
                        self.searchResults = userPieces + fetchedPieces
                    }
                } catch {
                    print("Error fetching pieces: \(error)")
                }
            case .denied:
                print("Denied")
            case .notDetermined:
                print("Not Determined")
            case .restricted:
                print("Restricted")
            default:
                print("Something happened")
            }
        }
    }

    func getUserPieces() async throws -> [Piece] {
        let response: [SupabasePieceResponse] = try await Database.client
            .from("pieces")
            .select("*, movements!inner(*), composer:composers!inner(id, name)")
            .ilike("work_name", pattern: "%\(searchTerm)%")
            .eq("user_id", value: Database.getCurrentUser()?.id.uuidString)
            .order("created_at", ascending: false)
            .execute()
            .value

        let pieces = mapResponseToFullPiece(response: response)

//        if let token = tokens.first {
//            return pieces.filter { piece in
//                piece.key_signature == token.type
//            }
//        }
        return pieces
    }

    func addKeySignatureToken(_ keySignature: KeySignatureType) {
        // Remove any existing tokens of type keySignature
        tokens.removeAll {
            if case .keySignature = $0.filterType {
                return true
            }
            return false
        }

        // Add the new token
        let newToken = FilterToken(filterType: .keySignature(keySignature))
        tokens.append(newToken)
    }

    func removeKeySignatureToken() {
        tokens.removeAll {
            if case .keySignature = $0.filterType {
                return true
            }
            return false
        }
    }
}

// struct KeySignatureToken: Identifiable, Hashable {
//    var id: UUID = .init()
//    var type: KeySignatureType?
//    var tonality: KeySignatureTonality?
//
//    var displayText: String {
//        if let type = type, let tonality = tonality {
//            return "\(type.rawValue) \(tonality.rawValue)"
//        } else if let type = type {
//            return type.rawValue
//        } else if let tonality = tonality {
//            return tonality.rawValue
//        } else {
//            return ""
//        }
//    }
//
//    mutating func updateTonality(_ newTonality: KeySignatureTonality) {
//        tonality = newTonality
//    }
//
//    static func from(type: KeySignatureType?, tonality: KeySignatureTonality?) -> KeySignatureToken? {
//        if let type = type {
//            if let tonality = tonality {
//                return KeySignatureToken(type: type, tonality: tonality)
//            } else {
//                return KeySignatureToken(type: type, tonality: nil)
//            }
//        } else if let tonality = tonality {
//            return KeySignatureToken(type: nil, tonality: tonality)
//        } else {
//            return nil
//        }
//    }
// }

struct FilterToken: Identifiable {
    var id: UUID = .init()
    var filterType: FilterType
    func displayText() -> String {
        switch filterType {
        case .keySignature(let keySignatureType):
            return keySignatureType.rawValue
        case .composer(let composer):
            return composer.name
        case .tonality(let tonality):
            return tonality.rawValue
        }
    }
}

enum FilterType {
    case keySignature(KeySignatureType)
    case composer(Composer)
    case tonality(KeySignatureTonality)
}
