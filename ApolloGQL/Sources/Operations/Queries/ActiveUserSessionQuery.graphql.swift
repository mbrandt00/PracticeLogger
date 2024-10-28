// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ActiveUserSessionQuery: GraphQLQuery {
  public static let operationName: String = "ActiveUserSession"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ActiveUserSession($userId: UUID!) { practiceSessionsCollection( filter: { userId: { eq: $userId }, endTime: { is: NULL } } first: 1 ) { __typename edges { __typename node { __typename ...PracticeSessionDetails } } } }"#,
      fragments: [PieceDetails.self, PracticeSessionDetails.self]
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
        "filter": [
          "userId": ["eq": .variable("userId")],
          "endTime": ["is": "NULL"]
        ],
        "first": 1
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
            .fragment(PracticeSessionDetails.self),
          ] }

          public var id: ApolloGQL.UUID { __data["id"] }
          public var startTime: ApolloGQL.Datetime { __data["startTime"] }
          public var endTime: ApolloGQL.Datetime? { __data["endTime"] }
          public var movement: Movement? { __data["movement"] }
          public var piece: Piece { __data["piece"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var practiceSessionDetails: PracticeSessionDetails { _toFragment() }
          }

          public typealias Movement = PracticeSessionDetails.Movement

          public typealias Piece = PracticeSessionDetails.Piece
        }
      }
    }
  }
}
