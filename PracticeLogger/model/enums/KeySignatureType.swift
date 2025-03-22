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
        case .c: return "C major"
        case .csharp: return "C♯ major"
        case .cflat: return "C♭ major"
        case .d: return "D major"
        case .dsharp: return "D♯ major"
        case .dflat: return "D♭ major"
        case .e: return "E major"
        case .esharp: return "E♯ major"
        case .eflat: return "E♭ major"
        case .f: return "F major"
        case .fsharp: return "F♯ major"
        case .fflat: return "F♭ major"
        case .g: return "G major"
        case .gsharp: return "G♯ major"
        case .gflat: return "G♭ major"
        case .a: return "A major"
        case .asharp: return "A♯ major"
        case .aflat: return "A♭ major"
        case .b: return "B major"
        case .bsharp: return "B♯ major"
        case .bflat: return "B♭ major"
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
