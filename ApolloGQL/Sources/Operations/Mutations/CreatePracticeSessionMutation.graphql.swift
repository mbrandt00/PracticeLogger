// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreatePracticeSessionMutation: GraphQLMutation {
  public static let operationName: String = "CreatePracticeSession"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreatePracticeSession($input: PracticeSessionsInsertInput!) { insertIntoPracticeSessionsCollection(objects: [$input]) { __typename records { __typename ...PracticeSessionDetails } } }"#,
      fragments: [PieceDetails.self, PracticeSessionDetails.self]
    ))

  public var input: PracticeSessionsInsertInput

  public init(input: PracticeSessionsInsertInput) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("insertIntoPracticeSessionsCollection", InsertIntoPracticeSessionsCollection?.self, arguments: ["objects": [.variable("input")]]),
    ] }

    /// Adds one or more `PracticeSessions` records to the collection
    public var insertIntoPracticeSessionsCollection: InsertIntoPracticeSessionsCollection? { __data["insertIntoPracticeSessionsCollection"] }

    public init(
      insertIntoPracticeSessionsCollection: InsertIntoPracticeSessionsCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Mutation.typename,
          "insertIntoPracticeSessionsCollection": insertIntoPracticeSessionsCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreatePracticeSessionMutation.Data.self)
        ]
      ))
    }

    /// InsertIntoPracticeSessionsCollection
    ///
    /// Parent Type: `PracticeSessionsInsertResponse`
    public struct InsertIntoPracticeSessionsCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PracticeSessionsInsertResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("records", [Record].self),
      ] }

      /// Array of records impacted by the mutation
      public var records: [Record] { __data["records"] }

      public init(
        records: [Record]
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": ApolloGQL.Objects.PracticeSessionsInsertResponse.typename,
            "records": records._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreatePracticeSessionMutation.Data.InsertIntoPracticeSessionsCollection.self)
          ]
        ))
      }

      /// InsertIntoPracticeSessionsCollection.Record
      ///
      /// Parent Type: `PracticeSessions`
      public struct Record: ApolloGQL.SelectionSet {
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
              "durationSeconds": durationSeconds,
              "movement": movement._fieldData,
              "piece": piece._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(CreatePracticeSessionMutation.Data.InsertIntoPracticeSessionsCollection.Record.self),
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
