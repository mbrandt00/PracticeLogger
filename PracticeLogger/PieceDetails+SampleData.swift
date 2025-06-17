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
            ),
        ]

        // Create the edges using the nodes
        let edges = movementNodes.map { node in
            PieceDetails.Movements.Edge(node: node)
        }

        // Create the movements collection
        let movements = PieceDetails.Movements(edges: edges)

        // Create the composer
        let composer = PieceDetails.Composer(id: ApolloGQL.BigInt(1), firstName: "Johann", lastName: "Sebastian Bach")

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
            collection: Collection(name: "Cello suites"),
            catalogueNumber: 1007,
            nickname: nil,
            composerId: BigInt(456),
            composer: composer,
            movements: movements
        )
    }()

    static let previewBeethoven: PieceDetails = {
        // First create the movement nodes
        let movementNodes = [
            PieceDetails.Movements.Edge.Node(
                id: BigInt(10),
                lastPracticed: Date().addingTimeInterval(-518400), // 6 days ago
                totalPracticeTime: 4890,
                name: "Allegro",
                keySignature: GraphQLEnum(KeySignatureType.bflat),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(45678),
                number: 1
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(11),
                lastPracticed: Date().addingTimeInterval(-259200), // 3 days ago
                totalPracticeTime: 2340,
                name: "Scherzo: Assai vivace",
                keySignature: GraphQLEnum(KeySignatureType.bflat),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(45678),
                number: 2
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(12),
                lastPracticed: Date().addingTimeInterval(-86400), // 1 day ago
                totalPracticeTime: 5230,
                name: "Adagio sostenuto",
                keySignature: GraphQLEnum(KeySignatureType.fsharpminor),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(45678),
                number: 3
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(13),
                lastPracticed: Date().addingTimeInterval(-86400), // 1 day ago
                totalPracticeTime: 6120,
                name: "Largo - Allegro risoluto",
                keySignature: GraphQLEnum(KeySignatureType.bflat),
                nickname: "Fuga",
                downloadUrl: nil,
                pieceId: BigInt(45678),
                number: 4
            ),
        ]

        // Create the edges using the nodes
        let edges = movementNodes.map { node in
            PieceDetails.Movements.Edge(node: node)
        }

        // Create the movements collection
        let movements = PieceDetails.Movements(edges: edges)

        // Create the composer
        let composer = PieceDetails.Composer(id: ApolloGQL.BigInt(2), firstName: "Ludwig van", lastName: "Beethoven")

        // Create the main piece
        return PieceDetails(
            lastPracticed: Date().addingTimeInterval(-86400), // 1 day ago
            id: BigInt(45678),
            workName: "Piano Sonata No. 29",
            catalogueType: GraphQLEnum(CatalogueType.op.rawValue),
            keySignature: GraphQLEnum(KeySignatureType.bflat),
            format: GraphQLEnum(PieceFormat.sonata.rawValue),
            instrumentation: ["Piano"],
            wikipediaUrl: "https://en.wikipedia.org/wiki/Piano_Sonata_No._29_(Beethoven)",
            imslpUrl: "https://imslp.org/wiki/Piano_Sonata_No.29%2C_Op.106_(Beethoven%2C_Ludwig_van)",
            compositionYear: 1818,
            catalogueNumberSecondary: nil,
            catalogueTypeNumDesc: "Op. 106",
            compositionYearDesc: "1818",
            compositionYearString: "1818",
            pieceStyle: "Classical/Early Romantic",
            subPieceType: nil,
            subPieceCount: nil,
            collection: Collection(name: "Piano Sonatas"),
            catalogueNumber: 106,
            nickname: "Hammerklavier",
            composerId: BigInt(123),
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
            ),
        ]

        // Create the edges using the nodes
        let edges = movementNodes.map { node in
            PieceDetails.Movements.Edge(node: node)
        }

        // Create the movements collection
        let movements = PieceDetails.Movements(edges: edges)

        // Create the composer
        let composer = PieceDetails.Composer(id: ApolloGQL.BigInt(3), firstName: "Frédéric", lastName: "Chopin")

        // Create the main piece
        return PieceDetails(
            lastPracticed: nil,
            id: BigInt(34567),
            workName: "Nocturnes",
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
            collection: Collection(name: "Nocturnes"),
            catalogueNumber: 9,
            nickname: nil,
            composerId: BigInt(789),
            composer: composer,
            movements: movements
        )
    }()

    static let allPreviews = [previewBach, previewChopin, previewBeethoven]
}
