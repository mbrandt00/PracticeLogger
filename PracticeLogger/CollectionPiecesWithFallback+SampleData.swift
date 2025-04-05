//
//  CollectionPiecesWithFallback+SampleData.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/5/25.
//
import ApolloAPI
import ApolloGQL
import Foundation

extension CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection {
    static let previewRachmaninoff: CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection = {
        // Create the collection nodes
        let pieceNodes = [
            Edge.Node(
                collection: Edge.Node.Collection(name: "Rachmaninoff Piano Concertos and Variations"),
                piece: Edge.Node.Piece(
                    workName: "Piano Concerto No. 1",
                    id: BigInt(50001),
                    userId: nil // Default piece, not user-specific
                ),
                composer: Edge.Node.Composer(name: "Sergei Rachmaninoff")
            ),
            Edge.Node(
                collection: Edge.Node.Collection(name: "Rachmaninoff Piano Concertos and Variations"),
                piece: Edge.Node.Piece(
                    workName: "Piano Concerto No. 2",
                    id: BigInt(50002),
                    userId: ApolloGQL.UUID("f47ac10b-58cc-4372-a567-0e02b2c3d479") // User-specific entry
                ),
                composer: Edge.Node.Composer(name: "Sergei Rachmaninoff")
            ),
            Edge.Node(
                collection: Edge.Node.Collection(name: "Rachmaninoff Piano Concertos and Variations"),
                piece: Edge.Node.Piece(
                    workName: "Piano Concerto No. 3",
                    id: BigInt(50003),
                    userId: ApolloGQL.UUID("f47ac10b-58cc-4372-a567-0e02b2c3d479") // User-specific entry
                ),
                composer: Edge.Node.Composer(name: "Sergei Rachmaninoff")
            ),
            Edge.Node(
                collection: Edge.Node.Collection(name: "Rachmaninoff Piano Concertos and Variations"),
                piece: Edge.Node.Piece(
                    workName: "Piano Concerto No. 4",
                    id: BigInt(50004),
                    userId: nil // Default piece, not user-specific
                ),
                composer: Edge.Node.Composer(name: "Sergei Rachmaninoff")
            ),
            Edge.Node(
                collection: Edge.Node.Collection(name: "Rachmaninoff Piano Concertos and Variations"),
                piece: Edge.Node.Piece(
                    workName: "Rhapsody on a Theme of Paganini",
                    id: BigInt(50005),
                    userId: nil // Default piece, not user-specific
                ),
                composer: Edge.Node.Composer(name: "Sergei Rachmaninoff")
            )
        ]

        // Create the edges using the nodes
        let edges = pieceNodes.map { node in
            Edge(node: node)
        }

        // Create the collection
        return CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection(
            edges: edges
        )
    }()
}

// Example usage:
