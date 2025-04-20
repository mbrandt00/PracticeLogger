//
//  SetString.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/14/24.
//

import Foundation

extension Set where Element == String {
    func formatKeySignature() -> String? {
        let keyCharacters: Set<Character> = ["a", "b", "c", "d", "e", "f", "g"]
        let tonalities = ["major", "minor"]
        let flatSymbols = ["♭", "flat", "b"]
        let sharpSymbols = ["♯", "#", "sharp"]
        let accidentals = ["flat", "sharp", "#", "b"]

        let elementsArray = Array(self)

        switch elementsArray.count {
        case 2:
            let keyElement = elementsArray.first { keyCharacters.contains($0.first!) }
            let nonKeyElement = elementsArray.first { !keyCharacters.contains($0.first!) }

            if let keyElement, let nonKeyElement {
                let tonalityValue = tonalities.contains(nonKeyElement) ? nonKeyElement.capitalized : ""
                return "\(keyElement.capitalized) \(tonalityValue)"
            }

        case 3:
            if let tonalityValueIndex = elementsArray.firstIndex(where: { tonalities.contains($0.lowercased()) }) {
                var keyCharacter = ""
                var accidental = ""

                for word in elementsArray {
                    if word == "b" || flatSymbols.contains(word) {
                        // Handle flats
                        accidental = flatSymbols[0] // Assume flats over sharps
                    }
                    if keyCharacters.contains(word) && keyCharacter.isEmpty {
                        keyCharacter = word.capitalized
                    } else if accidentals.contains(word) && accidental.isEmpty {
                        accidental = word
                    }
                }

                let tonalityValue = elementsArray[tonalityValueIndex].capitalized
                if accidental == flatSymbols[0] {
                    return "\(keyCharacter)\(flatSymbols[0]) \(tonalityValue)"
                } else {
                    return "\(keyCharacter)\(sharpSymbols[0]) \(tonalityValue)"
                }
            }

        default: return nil
        }
        return nil
    }
}
