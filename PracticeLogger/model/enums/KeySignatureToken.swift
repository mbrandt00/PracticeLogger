//
//  KeySignatureToken.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Foundation

import Foundation

enum KeySignatureToken: Identifiable, Hashable {
    case type(KeySignatureType)
    case tonality(KeySignatureTonality)
    case both(KeySignatureType, KeySignatureTonality)
    
    var id: UUID {
        return UUID()
    }
    
    var displayText: String {
        switch self {
        case .type(let type):
            return type.rawValue
        case .tonality(let tonality):
            return tonality.rawValue
        case .both(let type, let tonality):
            return "\(type.rawValue) \(tonality.rawValue)"
        }
    }
    
    static func from(type: KeySignatureType?, tonality: KeySignatureTonality?) -> KeySignatureToken? {
        if let type = type {
            return .type(type)
        } else if let tonality = tonality {
            return .tonality(tonality)
        } else if let type = type, let tonality = tonality {
            return .both(type, tonality)
        } else {
            return nil
        }
    }
    
    static func generateAllTokens() -> [KeySignatureToken] {
        var allTokens: [KeySignatureToken] = []
        
        // Adding tokens with type only
        for type in KeySignatureType.allCases {
            allTokens.append(.type(type))
        }
        
        // Adding tokens with tonality only
        for tonality in KeySignatureTonality.allCases {
            allTokens.append(.tonality(tonality))
        }
        
        // Adding tokens with both type and tonality
        for type in KeySignatureType.allCases {
            for tonality in KeySignatureTonality.allCases {
                allTokens.append(.both(type, tonality))
            }
        }
        
        return allTokens
    }
}
