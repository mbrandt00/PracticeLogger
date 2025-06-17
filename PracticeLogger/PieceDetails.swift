//
//  PieceDetails.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/1/25.
//
import ApolloGQL

extension PieceDetails: @retroactive Identifiable {
    static var empty: PieceDetails {
        PieceDetails(
            id: "temp_id",
            workName: "",
            catalogueType: nil,
            keySignature: nil,
            format: nil,
            instrumentation: [],
            wikipediaUrl: nil,
            compositionYear: nil,
            catalogueNumber: nil,
            nickname: nil,
            composer: nil,
            movements: PieceDetails.Movements(edges: [])
        )
    }
}
