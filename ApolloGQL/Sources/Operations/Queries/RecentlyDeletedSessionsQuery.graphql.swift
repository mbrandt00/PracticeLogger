// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class RecentlyDeletedSessionsQuery: GraphQLQuery {
  public static let operationName: String = "RecentlyDeletedSessions"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RecentlyDeletedSessions($userId: UUID!) { practiceSessionsCollection( filter: { userId: { eq: $userId }, deletedAt: { is: NOT_NULL } } orderBy: { deletedAt: DescNullsFirst } ) { __typename edges { __typename node { __typename ...PracticeSessionDetails } } } }"#,
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
          "deletedAt": ["is": "NOT_NULL"]
        ],
        "orderBy": ["deletedAt": "DescNullsFirst"]
      ]),
    ] }

    /// A pagable collection of type `PracticeSessions`
    public var practiceSessionsCollection: PracticeSessionsCollection? { __data["practiceSessionsCollection"] }

    public init(
      practiceSessionsCollection: PracticeSessionsCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "practiceSessionsCollection": practiceSessionsCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RecentlyDeletedSessionsQuery.Data.self)
        ]
      ))
    }

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

      public init(
        edges: [Edge]
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": ApolloGQL.Objects.PracticeSessionsConnection.typename,
            "edges": edges._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(RecentlyDeletedSessionsQuery.Data.PracticeSessionsCollection.self)
          ]
        ))
      }

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

        public init(
          node: Node
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": ApolloGQL.Objects.PracticeSessionsEdge.typename,
              "node": node._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(RecentlyDeletedSessionsQuery.Data.PracticeSessionsCollection.Edge.self)
            ]
          ))
        }

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

          public var id: ApolloGQL.BigInt { __data["id"] }
          public var startTime: ApolloGQL.Datetime { __data["startTime"] }
          public var endTime: ApolloGQL.Datetime? { __data["endTime"] }
          public var deletedAt: ApolloGQL.Datetime? { __data["deletedAt"] }
          public var durationSeconds: Int? { __data["durationSeconds"] }
          public var movement: Movement? { __data["movement"] }
          public var piece: Piece { __data["piece"] }

          public struct Fragments: FragmentContainer {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public var practiceSessionDetails: PracticeSessionDetails { _toFragment() }
          }

          public init(
            id: ApolloGQL.BigInt,
            startTime: ApolloGQL.Datetime,
            endTime: ApolloGQL.Datetime? = nil,
            deletedAt: ApolloGQL.Datetime? = nil,
            durationSeconds: Int? = nil,
            movement: Movement? = nil,
            piece: Piece
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.PracticeSessions.typename,
                "id": id,
                "startTime": startTime,
                "endTime": endTime,
                "deletedAt": deletedAt,
                "durationSeconds": durationSeconds,
                "movement": movement._fieldData,
                "piece": piece._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(RecentlyDeletedSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.self),
                ObjectIdentifier(PracticeSessionDetails.self)
              ]
            ))
          }

          public typealias Movement = PracticeSessionDetails.Movement

          public typealias Piece = PracticeSessionDetails.Piece
        }
      }
    }
  }
}
