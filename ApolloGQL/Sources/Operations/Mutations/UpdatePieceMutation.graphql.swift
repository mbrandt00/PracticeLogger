// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class UpdatePieceMutation: GraphQLMutation {
  public static let operationName: String = "UpdatePiece"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdatePiece($set: PieceUpdateInput!, $filter: PieceFilter) { updatePieceCollection(set: $set, filter: $filter) { __typename records { __typename ...PieceDetails } } }"#,
      fragments: [PieceDetails.self]
    ))

  public var set: PieceUpdateInput
  public var filter: GraphQLNullable<PieceFilter>

  public init(
    set: PieceUpdateInput,
    filter: GraphQLNullable<PieceFilter>
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
      .field("updatePieceCollection", UpdatePieceCollection.self, arguments: [
        "set": .variable("set"),
        "filter": .variable("filter")
      ]),
    ] }

    /// Updates zero or more records in the `Piece` collection
    public var updatePieceCollection: UpdatePieceCollection { __data["updatePieceCollection"] }

    public init(
      updatePieceCollection: UpdatePieceCollection
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Mutation.typename,
          "updatePieceCollection": updatePieceCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(UpdatePieceMutation.Data.self)
        ]
      ))
    }

    /// UpdatePieceCollection
    ///
    /// Parent Type: `PieceUpdateResponse`
    public struct UpdatePieceCollection: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PieceUpdateResponse }
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
            "__typename": ApolloGQL.Objects.PieceUpdateResponse.typename,
            "records": records._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(UpdatePieceMutation.Data.UpdatePieceCollection.self)
          ]
        ))
      }

      /// UpdatePieceCollection.Record
      ///
      /// Parent Type: `Piece`
      public struct Record: ApolloGQL.SelectionSet {
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
        public var searchableText: String? { __data["searchableText"] }
        public var subPieceCount: Int? { __data["subPieceCount"] }
        public var userId: ApolloGQL.UUID? { __data["userId"] }
        public var catalogueNumber: Int? { __data["catalogueNumber"] }
        public var nickname: String? { __data["nickname"] }
        public var composerId: ApolloGQL.BigInt? { __data["composerId"] }
        public var collections: Collections? { __data["collections"] }
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
          searchableText: String? = nil,
          subPieceCount: Int? = nil,
          userId: ApolloGQL.UUID? = nil,
          catalogueNumber: Int? = nil,
          nickname: String? = nil,
          composerId: ApolloGQL.BigInt? = nil,
          collections: Collections? = nil,
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
              "searchableText": searchableText,
              "subPieceCount": subPieceCount,
              "userId": userId,
              "catalogueNumber": catalogueNumber,
              "nickname": nickname,
              "composerId": composerId,
              "collections": collections._fieldData,
              "composer": composer._fieldData,
              "movements": movements._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(UpdatePieceMutation.Data.UpdatePieceCollection.Record.self),
              ObjectIdentifier(PieceDetails.self)
            ]
          ))
        }

        public typealias Collections = PieceDetails.Collections

        public typealias Composer = PieceDetails.Composer

        public typealias Movements = PieceDetails.Movements
      }
    }
  }
}
