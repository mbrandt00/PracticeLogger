//
//  Collections+SampleData.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/5/25.
//
import ApolloAPI
import ApolloGQL
import Foundation

//
// extension CollectionsQuery.Data.CollectionsCollection {
//    static let previewRachmaninoff: [CollectionsQuery.Data.CollectionsCollection.Edge] = {
//        // Create individual piece nodes for Piano Concertos
//        let pieces = [
//            CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge.Node(
//                workName: "Piano Concerto No. 1",
//                userId: nil
//            ),
//            CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge.Node(
//                workName: "Piano Concerto No. 2",
//                userId: ApolloGQL.UUID("12345") // With userId
//            ),
//            CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge.Node(
//                workName: "Piano Concerto No. 3",
//                userId: ApolloGQL.UUID("12345") // With userId
//            ),
//            CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge.Node(
//                workName: "Piano Concerto No. 4",
//                userId: nil
//            ),
//            CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge.Node(
//                workName: "Rhapsody on a Theme of Paganini",
//                userId: nil
//            )
//        ]
//
//        // Create piece edges
//        let pieceEdges = pieces.map { node in
//            CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge(node: node)
//        }
//
//        // Create pieces collection
//        let piecesCollection = CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces(edges: pieceEdges)
//
//        // Create composer
//        let composer = CollectionsQuery.Data.CollectionsCollection.Edge.Node.Composer(name: "Sergei Rachmaninoff")
//
//        // Create node
//        let node = CollectionsQuery.Data.CollectionsCollection.Edge.Node(
//            name: "Piano Concertos",
//            composer: composer,
//            pieces: piecesCollection
//        )
//
//        // Create edge and return as array
//        return [CollectionsQuery.Data.CollectionsCollection.Edge(node: node)]
//    }()
// }
//
//// Preview helper
// extension CollectionListView {
//    static var previewWithRachmaninoff: CollectionListView {
//        return CollectionListView(preview: CollectionsQuery.Data.CollectionsCollection.previewRachmaninoff)
//    }
// }
