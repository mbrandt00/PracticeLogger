//
//  String.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/30/24.
//

import Foundation

extension String {
    func isNumber() -> Bool {
        return Double(self) != nil
    }

    func containsKeySignature() -> Bool {
        let tonalities = ["major", "minor"]
        let keys = ["a", "b", "c", "d", "e", "f", "g"]
        let accidentals = ["flat", "sharp", "♯", "♭", "#", "b" ]

        let words = self.lowercased().split(separator: " ")
        for word in words {
            if tonalities.contains(String(word)) || keys.contains(String(word)) || accidentals.contains(String(word)) {
                return true
            }
        }
        return false
    }

    func parseKeySignature() -> Set<String> {
        let keyCharacters: Set<Character> = ["a", "b", "c", "d", "e", "f", "g"]
        let tonalities = ["major", "minor"]
        let accidentals = ["flat", "sharp", "♯", "♭", "#", "b" ]
        let string = self.lowercased()
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
                } else if tonalities.contains(String(word)) || keyCharacters.contains(String(word)) || accidentals.contains(String(word)) {
                    parsedQueryKeySignature.insert(String(word))
                }
            }
        }
        return parsedQueryKeySignature
    }

    func formatMovementName() -> String {
            // Define a pattern to match either a roman numeral or a number followed by a dot and a space
            let pattern = #"\b(?:[IVXLCDM]+|\d+)\.\s"# // Matches a roman numeral or a number followed by a dot and a space

            // Attempt to find the first match of the pattern in the string
            if let range = self.range(of: pattern, options: .regularExpression) {
                // Get the substring starting after the first occurrence of the match
                let startIndex = range.upperBound
                return String(self[startIndex...])
            }

            // Return the original string if no match is found
            return self
        }

}
