//
//  CatalogueType.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Foundation
import ApolloAPI
enum CatalogueType: String, Decodable, CaseIterable, Encodable, ApolloAPI.EnumType {
    case B, BWV, CPEB, D, DD, EG, FMW, H, K, L, Op, S, T, TH, VB, WAB, WD, WoO, Wq

    static var allCases: [CatalogueType] {
        return [
            .B, .BWV, .CPEB, .D, .DD, .EG, .FMW, .H, .K, .L, .Op, .S, .T, .TH, .VB, .WAB, .WD, .WoO, .Wq
        ]
    }
}
