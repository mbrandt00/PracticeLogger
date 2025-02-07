//
//  ImslpPieceDetails+SampleData.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/2/25.
//

import ApolloAPI
import ApolloGQL

extension ImslpPieceDetails {
    static let samplePieces: [ImslpPieceDetails] = [rachmaninoffPianoSonata2, beethovenHammerklavier, schubertLark, debussyPreludes, bachToccata]
    
    static let rachmaninoffPianoSonata2 = ImslpPieceDetails(
        imslpPieceId: BigInt(23456),
        id: ApolloGQL.BigInt(23456),
        workName: "Piano Sonata No. 2",
        catalogueType: GraphQLEnum(CatalogueType.op.rawValue),
        keySignature: GraphQLEnum(KeySignatureType.bflatminor),
        format: GraphQLEnum(PieceFormat.sonata.rawValue),
        instrumentation: ["Piano"],
        wikipediaUrl: "https://en.wikipedia.org/wiki/Piano_Sonata_No._2_(Rachmaninoff)",
        imslpUrl: "https://imslp.org/wiki/Piano_Sonata_No.2,_Op.36_(Rachmaninoff,_Sergei)",
        compositionYear: 1913,
        catalogueNumber: 36,
        nickname: "Sonata in B-flat minor",
        composer: ImslpPieceDetails.Composer(name: "Sergei Rachmaninoff"),
        movements: ImslpPieceDetails.Movements(
            edges: [
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "1",
                        name: "Allegro agitato",
                        pieceId: ApolloGQL.BigInt(23456),
                        number: 1
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "2",
                        name: "Non allegro - Lento",
                        pieceId: ApolloGQL.BigInt(23456),
                        number: 2
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "3",
                        name: "Allegro molto",
                        pieceId: ApolloGQL.BigInt(23456),
                        number: 3
                    )
                )
            ]
        )
    )
    
    static let beethovenHammerklavier = ImslpPieceDetails(
        imslpPieceId: BigInt(34567),
        id: ApolloGQL.BigInt(34567),
        workName: "Piano Sonata No. 29",
        catalogueType: GraphQLEnum(CatalogueType.op.rawValue),
        keySignature: GraphQLEnum(KeySignatureType.bflat),
        format: GraphQLEnum(PieceFormat.sonata.rawValue),
        instrumentation: ["Piano"],
        wikipediaUrl: "https://en.wikipedia.org/wiki/Piano_Sonata_No._29_(Beethoven)",
        imslpUrl: "https://imslp.org/wiki/Piano_Sonata_No.29,_Op.106_(Beethoven,_Ludwig_van)",
        compositionYear: 1818,
        catalogueNumber: 106,
        nickname: "Hammerklavier",
        composer: ImslpPieceDetails.Composer(name: "Ludwig van Beethoven"),
        movements: ImslpPieceDetails.Movements(
            edges: [
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "1",
                        name: "Allegro",
                        pieceId: ApolloGQL.BigInt(34567),
                        number: 1
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "2",
                        name: "Scherzo: Assai vivace",
                        pieceId: ApolloGQL.BigInt(34567),
                        number: 2
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "3",
                        name: "Adagio sostenuto",
                        pieceId: ApolloGQL.BigInt(34567),
                        number: 3
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "4",
                        name: "Largo - Allegro risoluto",
                        pieceId: ApolloGQL.BigInt(34567),
                        number: 4
                    )
                )
            ]
        )
    )
    
    static let schubertLark = ImslpPieceDetails(
        imslpPieceId: BigInt(45678),
        id: ApolloGQL.BigInt(45678),
        workName: "String Quartet No. 14",
        catalogueType: GraphQLEnum(CatalogueType.d.rawValue),
        keySignature: GraphQLEnum(KeySignatureType.a),
        format: GraphQLEnum(PieceFormat.stringQuartet.rawValue),
        instrumentation: ["Violin I", "Violin II", "Viola", "Cello"],
        wikipediaUrl: "https://en.wikipedia.org/wiki/String_Quartet_No._14_(Schubert)",
        imslpUrl: "https://imslp.org/wiki/String_Quartet_No.14,_D.804_(Schubert,_Franz)",
        compositionYear: 1824,
        catalogueNumber: 804,
        nickname: "Death and the Maiden",
        composer: ImslpPieceDetails.Composer(name: "Franz Schubert"),
        movements: ImslpPieceDetails.Movements(
            edges: [
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "1",
                        name: "Allegro moderato",
                        pieceId: ApolloGQL.BigInt(45678),
                        number: 1
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "2",
                        name: "Andante con moto",
                        pieceId: ApolloGQL.BigInt(45678),
                        number: 2
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "3",
                        name: "Menuetto: Allegretto - Trio",
                        pieceId: ApolloGQL.BigInt(45678),
                        number: 3
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "4",
                        name: "Allegro vivace",
                        pieceId: ApolloGQL.BigInt(45678),
                        number: 4
                    )
                )
            ]
        )
    )
    
    static let debussyPreludes = ImslpPieceDetails(
        imslpPieceId: BigInt(56789),
        id: ApolloGQL.BigInt(56789),
        workName: "Préludes, Book 1",
        catalogueType: GraphQLEnum(CatalogueType.lwv.rawValue), // L. needs to be added
        keySignature: nil,
        format: GraphQLEnum(PieceFormat.prelude.rawValue),
        instrumentation: ["Piano"],
        wikipediaUrl: "https://en.wikipedia.org/wiki/Préludes_(Debussy)",
        imslpUrl: "https://imslp.org/wiki/Préludes_(Book_1)_(Debussy,_Claude)",
        compositionYear: 1910,
        catalogueNumber: 117,
        nickname: "Préludes, Premier Livre",
        composer: ImslpPieceDetails.Composer(name: "Claude Debussy"),
        movements: ImslpPieceDetails.Movements(
            edges: [
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "1",
                        name: "Danseuses de Delphes",
                        pieceId: ApolloGQL.BigInt(56789),
                        number: 1
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "2",
                        name: "Voiles",
                        pieceId: ApolloGQL.BigInt(56789),
                        number: 2
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "3",
                        name: "Le vent dans la plaine",
                        pieceId: ApolloGQL.BigInt(56789),
                        number: 3
                    )
                )
            ]
        )
    )
    
    static let bachToccata = ImslpPieceDetails(
        imslpPieceId: BigInt(67890),
        id: ApolloGQL.BigInt(67890),
        workName: "Toccata and Fugue",
        catalogueType: GraphQLEnum(CatalogueType.bwv.rawValue),
        keySignature: GraphQLEnum(KeySignatureType.dminor),
        format: GraphQLEnum(PieceFormat.toccata.rawValue),
        instrumentation: ["Organ"],
        wikipediaUrl: "https://en.wikipedia.org/wiki/Toccata_and_Fugue_in_D_minor,_BWV_565",
        imslpUrl: "https://imslp.org/wiki/Toccata_and_Fugue_in_D_minor,_BWV_565_(Bach,_Johann_Sebastian)",
        compositionYear: 1704,
        catalogueNumber: 565,
        nickname: "Toccata and Fugue in D minor",
        composer: ImslpPieceDetails.Composer(name: "Johann Sebastian Bach"),
        movements: ImslpPieceDetails.Movements(
            edges: [
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "1",
                        name: "Toccata",
                        pieceId: ApolloGQL.BigInt(67890),
                        number: 1
                    )
                ),
                ImslpPieceDetails.Movements.Edge(
                    node: ImslpPieceDetails.Movements.Edge.Node(
                        id: "2",
                        name: "Fugue",
                        pieceId: ApolloGQL.BigInt(67890),
                        number: 2
                    )
                )
            ]
        )
    )
}
