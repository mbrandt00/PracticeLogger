//
//  CatalogueType.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import ApolloGQL

extension CatalogueType {
    var displayName: String {
        switch self {
        // Common catalogue numbers
        case .op: return "Op."
        case .k: return "K."
        case .bwv: return "BWV"
        case .d: return "D."
        case .hob: return "Hob."
        case .rv: return "RV"
        case .twv: return "TWV"
        case .hwv: return "HWV"
        case .sz: return "Sz."
        case .wwv: return "WWV"
        case .mwv: return "MWV"
        case .woo: return "WoO"
        case .wq: return "Wq."
        // Cases that should be uppercase
        case .wd, .wab, .eg, .th, .cff, .trv, .fp, .ms, .jb, .bv, .jw,
             .cnw, .lwv, .cd:
            return self.rawValue.uppercased()
        // Special cases
        case .do: return "Do."
        // Single letter cases
        case .b, .h, .s, .m:
            return "\(self.rawValue.uppercased())."
        }
    }
}
