// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdateMovementsMutation: GraphQLMutation {
  public static let operationName: String = "UpdateMovementsMutation"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateMovementsMutation($set: MovementUpdateInput!, $filter: MovementFilter) { updateMovementCollection(set: $set, filter: $filter) { __typename records { __typename number name id } } }"#
    ))

  public var set: MovementUpdateInput
  public var filter: GraphQLNullable<MovementFilter>

  public init(
    set: MovementUpdateInput,
    filter: GraphQLNullable<MovementFilter>
  ) {
    self.set = set
    self.filter = filter
  }

  public var __variables: Variables? { [
    "set": set,
    "filter": filter
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("updateMovementCollection", UpdateMovementCollection.self, arguments: [
        "set": .variable("set"),
        "filter": .variable("filter")
      ]),
    ] }

    /// Updates zero or more records in the `Movement` collection
    public var updateMovementCollection: UpdateMovementCollection { __data["updateMovementCollection"] }

    public init(
      updateMovementCollection: UpdateMovementCollection
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Mutation.typename,
          "updateMovementCollection": updateMovementCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(UpdateMovementsMutation.Data.self)
        ]
      ))
    }

    /// UpdateMovementCollection
    ///
    /// Parent Type: `MovementUpdateResponse`
    public struct UpdateMovementCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementUpdateResponse }
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
            "__typename": ApolloGQL.Objects.MovementUpdateResponse.typename,
            "records": records._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(UpdateMovementsMutation.Data.UpdateMovementCollection.self)
          ]
        ))
      }

      /// UpdateMovementCollection.Record
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
              ObjectIdentifier(UpdateMovementsMutation.Data.UpdateMovementCollection.Record.self)
            ]
          ))
        }
      }
    }
  }
}
