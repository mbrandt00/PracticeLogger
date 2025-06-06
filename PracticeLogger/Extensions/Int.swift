//
//  Int.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/14/24.
//

import Foundation

extension Int {
    func toRomanNumeral() -> String? {
        let numberToRoman: [Int: String] = [
            1: "I", 2: "II", 3: "III", 4: "IV", 5: "V",
            6: "VI", 7: "VII", 8: "VIII", 9: "IX", 10: "X",
            11: "XI", 12: "XII", 13: "XIII", 14: "XIV", 15: "XV",
            16: "XVI", 17: "XVII", 18: "XVIII", 19: "XIX", 20: "XX",
            21: "XXI", 22: "XXII", 23: "XXIII", 24: "XXIV", 25: "XXV",
            26: "XXVI", 27: "XXVII", 28: "XXVIII", 29: "XXIX", 30: "XXX",
            31: "XXXI", 32: "XXXII", 33: "XXXIII", 34: "XXXIV", 35: "XXXV",
            36: "XXXVI", 37: "XXXVII", 38: "XXXVIII", 39: "XXXIX", 40: "XL",
            41: "XLI", 42: "XLII", 43: "XLIII", 44: "XLIV", 45: "XLV",
            46: "XLVI", 47: "XLVII", 48: "XLVIII", 49: "XLIX", 50: "L",
        ]
        return numberToRoman[self]
    }

    var formattedTimeDuration: String {
        if self < 60 {
            return "\(self) seconds"
        } else if self < 3600 {
            let minutes = self / 60
            return "\(minutes) minute\(minutes != 1 ? "s" : "")"
        } else {
            let hours = self / 3600
            let remainingMinutes = (self % 3600) / 60
            if remainingMinutes == 0 {
                return "\(hours) hour\(hours != 1 ? "s" : "")"
            } else {
                return "\(hours) hour\(hours != 1 ? "s" : "") \(remainingMinutes) minute\(remainingMinutes != 1 ? "s" : "")"
            }
        }
    }
}
