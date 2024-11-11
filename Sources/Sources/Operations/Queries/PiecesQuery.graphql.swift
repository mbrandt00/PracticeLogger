// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class PiecesQuery: GraphQLQuery {
  public static let operationName: String = "PiecesQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query PiecesQuery($pieceFilter: PiecesFilter!) { piecesCollection(filter: $pieceFilter) { __typename edges { __typename node { __typename ...PieceDetails } } } }"#,
      fragments: [PieceDetails.self]
    ))

  public var pieceFilter: PiecesFilter

  public init(pieceFilter: PiecesFilter) {
    self.pieceFilter = pieceFilter
  }

  public var __variables: Variables? { ["pieceFilter": pieceFilter] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("piecesCollection", PiecesCollection?.self, arguments: ["filter": .variable("pieceFilter")]),
    ] }

    /// A pagable collection of type `Pieces`
    public var piecesCollection: PiecesCollection? { __data["piecesCollection"] }

    /// PiecesCollection
    ///
    /// Parent Type: `PiecesConnection`
    public struct PiecesCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PiecesConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("edges", [Edge].self),
      ] }

      public var edges: [Edge] { __data["edges"] }

      /// PiecesCollection.Edge
      ///
      /// Parent Type: `PiecesEdge`
      public struct Edge: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PiecesEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("node", Node.self),
        ] }

        public var node: Node { __data["node"] }

        /// PiecesCollection.Edge.Node
        ///
        /// Parent Type: `Pieces`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Pieces }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(PieceDetails.self),
          ] }

          public var id: ApolloGQL.BigInt { __data["id"] }
          public var workName: String { __data["workName"] }
          public var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? { __data["catalogueType"] }
          public var catalogueNumber: Int? { __data["catalogueNumber"] }
          public var nickname: String? { __data["nickname"] }
          public var composer: Composer? { __data["composer"] }
          public var movements: Movements? { __data["movements"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var pieceDetails: PieceDetails { _toFragment() }
          }

          public typealias Composer = PieceDetails.Composer

          public typealias Movements = PieceDetails.Movements
        }
      }
    }
  }
}
