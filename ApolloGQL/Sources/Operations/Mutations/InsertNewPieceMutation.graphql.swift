// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class InsertNewPieceMutation: GraphQLMutation {
  public static let operationName: String = "InsertNewPiece"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation InsertNewPiece($input: [PiecesInsertInput!]!) { insertIntoPiecesCollection(objects: $input) { __typename records { __typename ...PieceDetails } } }"#,
      fragments: [PieceDetails.self]
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

    public init(
      insertIntoPiecesCollection: InsertIntoPiecesCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Mutation.typename,
          "insertIntoPiecesCollection": insertIntoPiecesCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(InsertNewPieceMutation.Data.self)
        ]
      ))
    }

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

      public init(
        records: [Record]
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": ApolloGQL.Objects.PiecesInsertResponse.typename,
            "records": records._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(InsertNewPieceMutation.Data.InsertIntoPiecesCollection.self)
          ]
        ))
      }

      /// InsertIntoPiecesCollection.Record
      ///
      /// Parent Type: `Pieces`
      public struct Record: ApolloGQL.SelectionSet {
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
        public var instrumentation: [String?]? { __data["instrumentation"] }
        public var wikipediaUrl: String? { __data["wikipediaUrl"] }
        public var imslpUrl: String? { __data["imslpUrl"] }
        public var compositionYear: Int? { __data["compositionYear"] }
        public var catalogueNumber: Int? { __data["catalogueNumber"] }
        public var nickname: String? { __data["nickname"] }
        public var composer: Composer? { __data["composer"] }
        public var movements: Movements? { __data["movements"] }

        public struct Fragments: FragmentContainer {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public var pieceDetails: PieceDetails { _toFragment() }
        }

        public init(
          id: ApolloGQL.BigInt,
          workName: String,
          catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? = nil,
          keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
          format: GraphQLEnum<ApolloGQL.PieceFormat>? = nil,
          instrumentation: [String?]? = nil,
          wikipediaUrl: String? = nil,
          imslpUrl: String? = nil,
          compositionYear: Int? = nil,
          catalogueNumber: Int? = nil,
          nickname: String? = nil,
          composer: Composer? = nil,
          movements: Movements? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": ApolloGQL.Objects.Pieces.typename,
              "id": id,
              "workName": workName,
              "catalogueType": catalogueType,
              "keySignature": keySignature,
              "format": format,
              "instrumentation": instrumentation,
              "wikipediaUrl": wikipediaUrl,
              "imslpUrl": imslpUrl,
              "compositionYear": compositionYear,
              "catalogueNumber": catalogueNumber,
              "nickname": nickname,
              "composer": composer._fieldData,
              "movements": movements._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(InsertNewPieceMutation.Data.InsertIntoPiecesCollection.Record.self),
              ObjectIdentifier(PieceDetails.self)
            ]
          ))
        }

        public typealias Composer = PieceDetails.Composer

        public typealias Movements = PieceDetails.Movements
      }
    }
  }
}
