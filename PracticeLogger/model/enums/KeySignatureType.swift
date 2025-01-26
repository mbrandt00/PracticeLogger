//
//  KeySignatureType.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import ApolloAPI
import ApolloGQL
import Foundation

extension KeySignatureType {
    var displayName: String {
        switch self {
        case .c: return "C"
        case .csharp: return "C♯"
        case .cflat: return "C♭"
        case .d: return "D"
        case .dsharp: return "D♯"
        case .dflat: return "D♭"
        case .e: return "E"
        case .esharp: return "E♯"
        case .eflat: return "E♭"
        case .f: return "F"
        case .fsharp: return "F♯"
        case .fflat: return "F♭"
        case .g: return "G"
        case .gsharp: return "G♯"
        case .gflat: return "G♭"
        case .a: return "A"
        case .asharp: return "A♯"
        case .aflat: return "A♭"
        case .b: return "B"
        case .bsharp: return "B♯"
        case .bflat: return "B♭"
        // Minor keys
        case .cminor: return "C minor"
        case .csharpminor: return "C♯ minor"
        case .cflatminor: return "C♭ minor"
        case .dminor: return "D minor"
        case .dsharpminor: return "D♯ minor"
        case .dflatminor: return "D♭ minor"
        case .eminor: return "E minor"
        case .esharpminor: return "E♯ minor"
        case .eflatminor: return "E♭ minor"
        case .fminor: return "F minor"
        case .fsharpminor: return "F♯ minor"
        case .fflatminor: return "F♭ minor"
        case .gminor: return "G minor"
        case .gsharpminor: return "G♯ minor"
        case .gflatminor: return "G♭ minor"
        case .aminor: return "A minor"
        case .asharpminor: return "A♯ minor"
        case .aflatminor: return "A♭ minor"
        case .bminor: return "B minor"
        case .bsharpminor: return "B♯ minor"
        case .bflatminor: return "B♭ minor"
        }
    }
}
