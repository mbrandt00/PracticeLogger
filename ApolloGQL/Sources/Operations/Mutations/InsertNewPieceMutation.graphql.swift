// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class InsertNewPieceMutation: GraphQLMutation {
  public static let operationName: String = "InsertNewPiece"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation InsertNewPiece($input: [PiecesInsertInput!]!) { insertIntoPiecesCollection(objects: $input) { __typename records { __typename id nickname } } }"#
    ))

  public var input: [PiecesInsertInput]

  public init(input: [PiecesInsertInput]) {
    self.input = input
  }

  public var __variables: Variables? { ["input": input] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Mutation }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("insertIntoPiecesCollection", InsertIntoPiecesCollection?.self, arguments: ["objects": .variable("input")]),
    ] }

    /// Adds one or more `Pieces` records to the collection
    public var insertIntoPiecesCollection: InsertIntoPiecesCollection? { __data["insertIntoPiecesCollection"] }

    /// InsertIntoPiecesCollection
    ///
    /// Parent Type: `PiecesInsertResponse`
    public struct InsertIntoPiecesCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PiecesInsertResponse }
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("records", [Record].self),
      ] }

      /// Array of records impacted by the mutation
      public var records: [Record] { __data["records"] }

      /// InsertIntoPiecesCollection.Record
      ///
      /// Parent Type: `Pieces`
      public struct Record: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Pieces }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ApolloGQL.UUID.self),
          .field("nickname", String?.self),
        ] }

        public var id: ApolloGQL.UUID { __data["id"] }
        public var nickname: String? { __data["nickname"] }
      }
    }
  }
}
