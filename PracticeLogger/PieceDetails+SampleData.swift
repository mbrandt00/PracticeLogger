//
//  PieceDetails+SampleData.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/15/25.
//

import ApolloAPI
import ApolloGQL

import ApolloAPI
import ApolloGQL

extension PieceDetails {
    static let preview: PieceDetails = {
        // First create the movement nodes
        let movementNodes = [
            PieceDetails.Movements.Edge.Node(
                id: BigInt(1),
                name: "I. Adagio sostenuto",
                keySignature: GraphQLEnum(KeySignatureType.csharpminor.rawValue),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(12345),
                number: 1
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(2),
                name: "II. Allegretto",
                keySignature: GraphQLEnum(KeySignatureType.dflat.rawValue),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(12345),
                number: 2
            ),
            PieceDetails.Movements.Edge.Node(
                id: BigInt(3),
                name: "III. Presto agitato",
                keySignature: GraphQLEnum(KeySignatureType.csharpminor.rawValue),
                nickname: nil,
                downloadUrl: nil,
                pieceId: BigInt(12345),
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
        let composer = PieceDetails.Composer(name: "Ludwig van Beethoven")

        // Create the main piece
        return PieceDetails(
            imslpPieceId: BigInt(12345),
            id: BigInt(12345),
            workName: "Piano Sonata No. 14",
            catalogueType: GraphQLEnum(CatalogueType.op.rawValue),
            keySignature: GraphQLEnum(KeySignatureType.csharpminor.rawValue),
            format: GraphQLEnum(PieceFormat.sonata.rawValue),
            instrumentation: ["Piano"],
            wikipediaUrl: "https://en.wikipedia.org/wiki/Piano_Sonata_No._14_(Beethoven)",
            imslpUrl: "https://imslp.org/wiki/Piano_Sonata_No.14,_Op.27_No.2_(Beethoven,_Ludwig_van)",
            compositionYear: 1801,
            catalogueNumberSecondary: 2,
            catalogueTypeNumDesc: "Op. 27 No. 2",
            compositionYearDesc: "1801",
            compositionYearString: "1801",
            pieceStyle: "Classical",
            subPieceType: nil,
            subPieceCount: nil,
            catalogueNumber: 27,
            nickname: "Moonlight Sonata",
            composerId: BigInt(123),
            composer: composer,
            movements: movements
        )
    }()
}
