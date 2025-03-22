//
//  PieceDetails+SampleData.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/15/25.
//

import ApolloAPI
import ApolloGQL
import Foundation

extension PieceDetails {
    static let previewBach: PieceDetails = {
        // First create the movement nodes
        let movementNodes = [
            PieceDetails.Movements.Edge.Node(
                id: BigInt(4),
                lastPracticed: Date().addingTimeInterval(-345600), // 4 days ago
                totalPracticeTime: 2456,
                name: "Prelude",
                keySignature: GraphQLEnum(KeySignatureType.c),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(23456),
                number: 1
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(5),
                lastPracticed: nil, // null lastPracticed
                totalPracticeTime: 1890,
                name: "Allemande",
                keySignature: GraphQLEnum(KeySignatureType.c),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(23456),
                number: 2
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(6),
                lastPracticed: Date().addingTimeInterval(-172800), // 2 days ago
                totalPracticeTime: 1340,
                name: "Courante",
                keySignature: GraphQLEnum(KeySignatureType.c),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(23456),
                number: 3
            )
        ]

        // Create the edges using the nodes
        let edges = movementNodes.map { node in
            PieceDetails.Movements.Edge(node: node)
        }

        // Create the movements collection
        let movements = PieceDetails.Movements(edges: edges)

        // Create the composer
        let composer = PieceDetails.Composer(name: "Johann Sebastian Bach")

        // Create the main piece
        return PieceDetails(
            lastPracticed: Date().addingTimeInterval(-172800), // 2 days ago
            id: BigInt(23456),
            workName: "Cello Suite No. 1",
            catalogueType: GraphQLEnum(CatalogueType.bwv.rawValue),
            keySignature: GraphQLEnum(KeySignatureType.c),
            format: GraphQLEnum(PieceFormat.suite.rawValue),
            instrumentation: ["Cello"],
            wikipediaUrl: "https://en.wikipedia.org/wiki/Cello_Suites_(Bach)",
            imslpUrl: "https://imslp.org/wiki/Cello_Suite_No.1_in_G_major,_BWV_1007_(Bach,_Johann_Sebastian)",
            compositionYear: 1717,
            catalogueNumberSecondary: nil,
            catalogueTypeNumDesc: "BWV 1007",
            compositionYearDesc: "1717",
            compositionYearString: "1717",
            pieceStyle: "Baroque",
            subPieceType: nil,
            subPieceCount: nil,
            catalogueNumber: 1007,
            nickname: nil,
            composerId: BigInt(456),
            composer: composer,
            movements: movements
        )
    }()

    static let previewChopin: PieceDetails = {
        // First create the movement nodes
        let movementNodes = [
            PieceDetails.Movements.Edge.Node(
                id: BigInt(7),
                lastPracticed: nil,
                totalPracticeTime: 3578,
                name: "Nocturne in E-flat major",
                keySignature: GraphQLEnum(KeySignatureType.eflat.rawValue),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(34567),
                number: 1
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(8),
                lastPracticed: nil,
                totalPracticeTime: 2145,
                name: "Nocturne in F minor",
                keySignature: GraphQLEnum(KeySignatureType.fminor.rawValue),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(34567),
                number: 2
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(9),
                lastPracticed: nil,
                totalPracticeTime: 1876,
                name: "Nocturne in B major",
                keySignature: GraphQLEnum(KeySignatureType.b),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(34567),
                number: 3
            )
        ]

        // Create the edges using the nodes
        let edges = movementNodes.map { node in
            PieceDetails.Movements.Edge(node: node)
        }

        // Create the movements collection
        let movements = PieceDetails.Movements(edges: edges)

        // Create the composer
        let composer = PieceDetails.Composer(name: "Frédéric Chopin")

        // Create the main piece
        return PieceDetails(
            lastPracticed: nil,
            id: BigInt(34567),
            workName: "Nocturnes, Op. 9",
            catalogueType: GraphQLEnum(CatalogueType.op.rawValue),
            keySignature: GraphQLEnum(KeySignatureType.eflat.rawValue),
            format: GraphQLEnum(PieceFormat.nocturne.rawValue),
            instrumentation: ["Piano"],
            wikipediaUrl: "https://en.wikipedia.org/wiki/Nocturnes,_Op._9_(Chopin)",
            imslpUrl: "https://imslp.org/wiki/Nocturnes,_Op.9_(Chopin,_Fr%C3%A9d%C3%A9ric)",
            compositionYear: 1832,
            catalogueNumberSecondary: nil,
            catalogueTypeNumDesc: "Op. 9",
            compositionYearDesc: "1832",
            compositionYearString: "1832",
            pieceStyle: "Romantic",
            subPieceType: "nocturnes",
            subPieceCount: nil,
            catalogueNumber: 9,
            nickname: nil,
            composerId: BigInt(789),
            composer: composer,
            movements: movements
        )
    }()

    static let allPreviews = [previewBach, previewChopin]
}
