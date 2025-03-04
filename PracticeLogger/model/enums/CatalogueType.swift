//
//  CatalogueType.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import ApolloGQL

extension GraphQLEnum where T == ApolloGQL.CatalogueType {
    var displayName: String {
        let typeString = self.rawValue

        switch typeString {
        case "op": return "Op."
        case "k": return "K."
        case "bwv": return "BWV"
        case "d": return "D."
        case "hob": return "Hob."
        case "rv": return "RV"
        case "twv": return "TWV"
        case "hwv": return "HWV"
        case "sz": return "Sz."
        case "wwv": return "WWV"
        case "mwv": return "MWV"
        case "woo": return "WoO"
        case "wq": return "Wq."
        case "wd", "wab", "eg", "th", "cff", "trv", "fp", "ms", "jb", "bv", "jw",
             "cnw", "lwv", "cd":
            return typeString.uppercased()
        case "do": return "Do."
        case "b", "h", "s", "m":
            return "\(typeString.uppercased())."
        // Default case
        default: return typeString
        }
    }
}
