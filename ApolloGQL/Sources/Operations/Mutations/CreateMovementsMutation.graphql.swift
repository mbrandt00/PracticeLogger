// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreateMovementsMutation: GraphQLMutation {
  public static let operationName: String = "CreateMovementsMutation"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateMovementsMutation($input: [MovementInsertInput!]!) { insertIntoMovementCollection(objects: $input) { __typename records { __typename number name id } } }"#
    ))

  public var input: [MovementInsertInput]

  public init(input: [MovementInsertInput]) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("insertIntoMovementCollection", InsertIntoMovementCollection?.self, arguments: ["objects": .variable("input")]),
    ] }

    /// Adds one or more `Movement` records to the collection
    public var insertIntoMovementCollection: InsertIntoMovementCollection? { __data["insertIntoMovementCollection"] }

    public init(
      insertIntoMovementCollection: InsertIntoMovementCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Mutation.typename,
          "insertIntoMovementCollection": insertIntoMovementCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreateMovementsMutation.Data.self)
        ]
      ))
    }

    /// InsertIntoMovementCollection
    ///
    /// Parent Type: `MovementInsertResponse`
    public struct InsertIntoMovementCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementInsertResponse }
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
            "__typename": ApolloGQL.Objects.MovementInsertResponse.typename,
            "records": records._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreateMovementsMutation.Data.InsertIntoMovementCollection.self)
          ]
        ))
      }

      /// InsertIntoMovementCollection.Record
      ///
      /// Parent Type: `Movement`
      public struct Record: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Movement }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("number", Int?.self),
          .field("name", String?.self),
          .field("id", ApolloGQL.BigInt.self),
        ] }

        public var number: Int? { __data["number"] }
        public var name: String? { __data["name"] }
        public var id: ApolloGQL.BigInt { __data["id"] }

        public init(
          number: Int? = nil,
          name: String? = nil,
          id: ApolloGQL.BigInt
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": ApolloGQL.Objects.Movement.typename,
              "number": number,
              "name": name,
              "id": id,
            ],
            fulfilledFragments: [
              ObjectIdentifier(CreateMovementsMutation.Data.InsertIntoMovementCollection.Record.self)
            ]
          ))
        }
      }
    }
  }
}
