// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SearchPiecesQuery: GraphQLQuery {
  public static let operationName: String = "SearchPieces"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SearchPieces($query: String!, $pieceFilter: PiecesFilter) { searchPieceWithAssociations(query: $query, filter: $pieceFilter) { __typename edges { __typename node { __typename ...PieceDetails } } } }"#,
      fragments: [PieceDetails.self]
    ))

  public var query: String
  public var pieceFilter: GraphQLNullable<PiecesFilter>

  public init(
    query: String,
    pieceFilter: GraphQLNullable<PiecesFilter>
  ) {
    self.query = query
    self.pieceFilter = pieceFilter
  }

  public var __variables: Variables? { [
    "query": query,
    "pieceFilter": pieceFilter
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("searchPieceWithAssociations", SearchPieceWithAssociations?.self, arguments: [
        "query": .variable("query"),
        "filter": .variable("pieceFilter")
      ]),
    ] }

    public var searchPieceWithAssociations: SearchPieceWithAssociations? { __data["searchPieceWithAssociations"] }

    /// SearchPieceWithAssociations
    ///
    /// Parent Type: `PiecesConnection`
    public struct SearchPieceWithAssociations: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PiecesConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("edges", [Edge].self),
      ] }

      public var edges: [Edge] { __data["edges"] }

      /// SearchPieceWithAssociations.Edge
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

        /// SearchPieceWithAssociations.Edge.Node
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
