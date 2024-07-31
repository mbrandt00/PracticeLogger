//
//  KeySignatureType.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

enum KeySignatureType: String, Decodable, Encodable, CaseIterable, Identifiable {
    case c = "C"
    case cSharp = "C♯"
    case cFlat = "C♭"
    case d = "D"
    case dSharp = "D♯"
    case dFlat = "D♭"
    case e = "E"
    case eSharp = "E♯"
    case eFlat = "E♭"
    case f = "F"
    case fSharp = "F♯"
    case fFlat = "F♭"
    case g = "G"
    case gSharp = "G♯"
    case gFlat = "G♭"
    case a = "A"
    case aSharp = "A♯"
    case aFlat = "A♭"
    case b = "B"
    case bSharp = "B♯"
    case bFlat = "B♭"
    
    var id: Self { self }
    
    static var allCases: [KeySignatureType] {
        return [
            .c, .cSharp, .cFlat,
            .d, .dSharp, .dFlat,
            .e, .eSharp, .eFlat,
            .f, .fSharp, .fFlat,
            .g, .gSharp, .gFlat,
            .a, .aSharp, .aFlat,
            .b, .bSharp, .bFlat
        ]
    }
    
    static func fromNormalizedString(_ string: String) -> KeySignatureType? {
        let normalizedString = normalizeString(string)
        
        var longestMatch: KeySignatureType? = nil
        var maxLength = 0
        
        for type in KeySignatureType.allCases {
            let typeString = normalizeString(type.rawValue)
            if normalizedString.contains(typeString) && typeString.count > maxLength {
                longestMatch = type
                maxLength = typeString.count
            }
        }
        
        return longestMatch
    }
    
    static func normalizeString(_ string: String) -> String {
        let lowercasedString = string.lowercased()
        return lowercasedString
            .replacingOccurrences(of: "sharp", with: "♯")
            .replacingOccurrences(of: "flat", with: "♭")
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }
}
