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

    public init(
      practiceSessionsCollection: PracticeSessionsCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "practiceSessionsCollection": practiceSessionsCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RecentUserSessionsQuery.Data.self)
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
            ObjectIdentifier(RecentUserSessionsQuery.Data.PracticeSessionsCollection.self)
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
              ObjectIdentifier(RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.self)
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

          public init(
            id: ApolloGQL.BigInt,
            startTime: ApolloGQL.Datetime,
            durationSeconds: Int? = nil,
            piece: Piece,
            endTime: ApolloGQL.Datetime? = nil,
            movement: Movement? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.PracticeSessions.typename,
                "id": id,
                "startTime": startTime,
                "durationSeconds": durationSeconds,
                "piece": piece._fieldData,
                "endTime": endTime,
                "movement": movement._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.self)
              ]
            ))
          }

          /// PracticeSessionsCollection.Edge.Node.Piece
          ///
          /// Parent Type: `Piece`
          public struct Piece: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Piece }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .fragment(PieceDetails.self),
            ] }

            public var lastPracticed: ApolloGQL.Datetime? { __data["lastPracticed"] }
            public var totalPracticeTime: Int? { __data["totalPracticeTime"] }
            public var id: ApolloGQL.BigInt { __data["id"] }
            public var workName: String { __data["workName"] }
            public var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? { __data["catalogueType"] }
            public var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? { __data["keySignature"] }
            public var format: GraphQLEnum<ApolloGQL.PieceFormat>? { __data["format"] }
            public var instrumentation: [String?]? { __data["instrumentation"] }
            public var wikipediaUrl: String? { __data["wikipediaUrl"] }
            public var imslpUrl: String? { __data["imslpUrl"] }
            public var compositionYear: Int? { __data["compositionYear"] }
            public var catalogueNumberSecondary: Int? { __data["catalogueNumberSecondary"] }
            public var catalogueTypeNumDesc: String? { __data["catalogueTypeNumDesc"] }
            public var compositionYearDesc: String? { __data["compositionYearDesc"] }
            public var compositionYearString: String? { __data["compositionYearString"] }
            public var pieceStyle: String? { __data["pieceStyle"] }
            public var subPieceType: String? { __data["subPieceType"] }
            public var subPieceCount: Int? { __data["subPieceCount"] }
            public var userId: ApolloGQL.UUID? { __data["userId"] }
            public var catalogueNumber: Int? { __data["catalogueNumber"] }
            public var nickname: String? { __data["nickname"] }
            public var composerId: ApolloGQL.BigInt? { __data["composerId"] }
            public var composer: Composer? { __data["composer"] }
            public var movements: Movements? { __data["movements"] }

            public struct Fragments: FragmentContainer {
              public let __data: DataDict
              public init(_dataDict: DataDict) { __data = _dataDict }

              public var pieceDetails: PieceDetails { _toFragment() }
            }

            public init(
              lastPracticed: ApolloGQL.Datetime? = nil,
              totalPracticeTime: Int? = nil,
              id: ApolloGQL.BigInt,
              workName: String,
              catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? = nil,
              keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
              format: GraphQLEnum<ApolloGQL.PieceFormat>? = nil,
              instrumentation: [String?]? = nil,
              wikipediaUrl: String? = nil,
              imslpUrl: String? = nil,
              compositionYear: Int? = nil,
              catalogueNumberSecondary: Int? = nil,
              catalogueTypeNumDesc: String? = nil,
              compositionYearDesc: String? = nil,
              compositionYearString: String? = nil,
              pieceStyle: String? = nil,
              subPieceType: String? = nil,
              subPieceCount: Int? = nil,
              userId: ApolloGQL.UUID? = nil,
              catalogueNumber: Int? = nil,
              nickname: String? = nil,
              composerId: ApolloGQL.BigInt? = nil,
              composer: Composer? = nil,
              movements: Movements? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": ApolloGQL.Objects.Piece.typename,
                  "lastPracticed": lastPracticed,
                  "totalPracticeTime": totalPracticeTime,
                  "id": id,
                  "workName": workName,
                  "catalogueType": catalogueType,
                  "keySignature": keySignature,
                  "format": format,
                  "instrumentation": instrumentation,
                  "wikipediaUrl": wikipediaUrl,
                  "imslpUrl": imslpUrl,
                  "compositionYear": compositionYear,
                  "catalogueNumberSecondary": catalogueNumberSecondary,
                  "catalogueTypeNumDesc": catalogueTypeNumDesc,
                  "compositionYearDesc": compositionYearDesc,
                  "compositionYearString": compositionYearString,
                  "pieceStyle": pieceStyle,
                  "subPieceType": subPieceType,
                  "subPieceCount": subPieceCount,
                  "userId": userId,
                  "catalogueNumber": catalogueNumber,
                  "nickname": nickname,
                  "composerId": composerId,
                  "composer": composer._fieldData,
                  "movements": movements._fieldData,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.Piece.self),
                  ObjectIdentifier(PieceDetails.self)
                ]
              ))
            }

            public typealias Composer = PieceDetails.Composer

            public typealias Movements = PieceDetails.Movements
          }

          /// PracticeSessionsCollection.Edge.Node.Movement
          ///
          /// Parent Type: `Movement`
          public struct Movement: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Movement }
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("name", String?.self),
            ] }

            public var name: String? { __data["name"] }

            public init(
              name: String? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": ApolloGQL.Objects.Movement.typename,
                  "name": name,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node.Movement.self)
                ]
              ))
            }
          }
        }
      }
    }
  }
}
