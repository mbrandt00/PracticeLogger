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

}
