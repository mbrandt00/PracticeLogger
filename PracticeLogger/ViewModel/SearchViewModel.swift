//
//  SearchViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchTerm = "" {
        didSet {
            if searchTerm.last == " " {
                updateTokens()
            }
        }
    }

    @Published var tokens: [KeySignatureToken] = []

    private var cancellables = Set<AnyCancellable>()
    func updateTokens() {
        // Ensure the last character is a space
        guard searchTerm.hasSuffix(" ") else {
            print("Search term does not end with a space. Exiting updateTokens.")
            return
        }

        // Define key signature patterns
        let accidentals = ["sharp", "flat", "♯", "♭", "#", "b"]
        let keys = ["a", "b", "c", "d", "e", "f", "g"]

        // Split the search term into words
        let words = searchTerm.lowercased().split(separator: " ").map { String($0) }

        // Identify and extract key signature
        for i in 0 ..< words.count {
            let word = words[i]

            // Check if the word is a key
            if keys.contains(word) {
                // Check if the next word is an accidental
                if i + 1 < words.count, accidentals.contains(words[i + 1]) {
                    let nextWord = words[i + 1]
                    let accidental = nextWord == "sharp" || nextWord == "♯" || nextWord == "#" ? "♯" : "♭"
                    let keySignature = "\(word)\(accidental)"
                    let keyType = KeySignatureType.fromNormalizedString(keySignature)

                    if let token = KeySignatureToken.from(type: keyType, tonality: nil) {
                        // Update the tokens array
                        tokens = [token]

                        // Remove the key signature part from searchTerm
                        let prefix = words.prefix(i).joined(separator: " ")
                        let suffix = words.dropFirst(i + 2).joined(separator: " ")
                        searchTerm = [prefix, suffix].joined(separator: " ").trimmingCharacters(in: .whitespaces)

                        print("Remaining string: \(searchTerm)")
                        print("Token: \(token)")
                        return
                    }
                } else {
                    if i + 1 < words.count && !accidentals.contains(words[i + 1]) {
                        let keySignature = word
                        let keyType = KeySignatureType.fromNormalizedString(keySignature)

                        if let token = KeySignatureToken.from(type: keyType, tonality: nil) {
                            // Update the tokens array
                            tokens = [token]

                            // Remove the key signature part from searchTerm
                            let prefix = words.prefix(i).joined(separator: " ")
                            let suffix = words.dropFirst(i + 1).joined(separator: " ")
                            searchTerm = [prefix, suffix].joined(separator: " ").trimmingCharacters(in: .whitespaces)

                            print("Remaining string: \(searchTerm)")
                            print("Token: \(token)")
                            return
                        }
                    }
                }
            }
        }
    }
}
