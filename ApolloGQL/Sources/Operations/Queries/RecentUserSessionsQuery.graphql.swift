// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RecentUserSessionsQuery: GraphQLQuery {
  public static let operationName: String = "RecentUserSessions"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RecentUserSessions($userId: UUID!) { practiceSessionsCollection( filter: { userId: { eq: $userId } } orderBy: { endTime: DescNullsFirst } ) { __typename edges { __typename node { __typename id startTime durationSeconds piece { __typename ...PieceDetails } endTime movement { __typename name } } } } }"#,
      fragments: [PieceDetails.self]
    ))

  public var userId: UUID

  public init(userId: UUID) {
    self.userId = userId
  }

  public var __variables: Variables? { ["userId": userId] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("practiceSessionsCollection", PracticeSessionsCollection?.self, arguments: [
        "filter": ["userId": ["eq": .variable("userId")]],
        "orderBy": ["endTime": "DescNullsFirst"]
      ]),
    ] }

    /// A pagable collection of type `PracticeSessions`
    public var practiceSessionsCollection: PracticeSessionsCollection? { __data["practiceSessionsCollection"] }

    /// PracticeSessionsCollection
    ///
    /// Parent Type: `PracticeSessionsConnection`
    public struct PracticeSessionsCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PracticeSessionsConnection }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("edges", [Edge].self),
      ] }

      public var edges: [Edge] { __data["edges"] }

      /// PracticeSessionsCollection.Edge
      ///
      /// Parent Type: `PracticeSessionsEdge`
      public struct Edge: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PracticeSessionsEdge }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("node", Node.self),
        ] }

        public var node: Node { __data["node"] }

        /// PracticeSessionsCollection.Edge.Node
        ///
        /// Parent Type: `PracticeSessions`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PracticeSessions }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ApolloGQL.BigInt.self),
            .field("startTime", ApolloGQL.Datetime.self),
            .field("durationSeconds", Int?.self),
            .field("piece", Piece.self),
            .field("endTime", ApolloGQL.Datetime?.self),
            .field("movement", Movement?.self),
          ] }

          public var id: ApolloGQL.BigInt { __data["id"] }
          public var startTime: ApolloGQL.Datetime { __data["startTime"] }
          public var durationSeconds: Int? { __data["durationSeconds"] }
          public var piece: Piece { __data["piece"] }
          public var endTime: ApolloGQL.Datetime? { __data["endTime"] }
          public var movement: Movement? { __data["movement"] }

          /// PracticeSessionsCollection.Edge.Node.Piece
          ///
          /// Parent Type: `Pieces`
          public struct Piece: ApolloGQL.SelectionSet {
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
            public var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? { __data["keySignature"] }
            public var format: GraphQLEnum<ApolloGQL.PieceFormat>? { __data["format"] }
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

          /// PracticeSessionsCollection.Edge.Node.Movement
          ///
          /// Parent Type: `Movements`
          public struct Movement: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Movements }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String?.self),
            ] }

            public var name: String? { __data["name"] }
          }
        }
      }
    }
  }
}
