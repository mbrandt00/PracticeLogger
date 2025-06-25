// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PieceDetails: ApolloGQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PieceDetails on Piece { __typename lastPracticed totalPracticeTime id workName catalogueType keySignature format instrumentation wikipediaUrl imslpUrl compositionYear catalogueNumberSecondary catalogueTypeNumDesc compositionYearDesc compositionYearString pieceStyle totalPracticeTime subPieceType searchableText subPieceCount userId collectionId collection { __typename name } catalogueNumber nickname composerId composer { __typename id userId firstName lastName nationality musicalEra } movements: movementCollection(orderBy: [{ number: AscNullsLast }]) { __typename edges { __typename node { __typename id lastPracticed totalPracticeTime name totalPracticeTime keySignature nickname downloadUrl pieceId number } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Piece }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("lastPracticed", ApolloGQL.Datetime?.self),
    .field("totalPracticeTime", Int?.self),
    .field("id", ApolloGQL.BigInt.self),
    .field("workName", String.self),
    .field("catalogueType", GraphQLEnum<ApolloGQL.CatalogueType>?.self),
    .field("keySignature", GraphQLEnum<ApolloGQL.KeySignatureType>?.self),
    .field("format", GraphQLEnum<ApolloGQL.PieceFormat>?.self),
    .field("instrumentation", [String?]?.self),
    .field("wikipediaUrl", String?.self),
    .field("imslpUrl", String?.self),
    .field("compositionYear", Int?.self),
    .field("catalogueNumberSecondary", Int?.self),
    .field("catalogueTypeNumDesc", String?.self),
    .field("compositionYearDesc", String?.self),
    .field("compositionYearString", String?.self),
    .field("pieceStyle", String?.self),
    .field("subPieceType", String?.self),
    .field("searchableText", String?.self),
    .field("subPieceCount", Int?.self),
    .field("userId", ApolloGQL.UUID?.self),
    .field("collectionId", ApolloGQL.BigInt?.self),
    .field("collection", Collection?.self),
    .field("catalogueNumber", Int?.self),
    .field("nickname", String?.self),
    .field("composerId", ApolloGQL.BigInt?.self),
    .field("composer", Composer?.self),
    .field("movementCollection", alias: "movements", Movements?.self, arguments: ["orderBy": [["number": "AscNullsLast"]]]),
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
  public var collectionId: ApolloGQL.BigInt? { __data["collectionId"] }
  public var collection: Collection? { __data["collection"] }
  public var catalogueNumber: Int? { __data["catalogueNumber"] }
  public var nickname: String? { __data["nickname"] }
  public var composerId: ApolloGQL.BigInt? { __data["composerId"] }
  public var composer: Composer? { __data["composer"] }
  public var movements: Movements? { __data["movements"] }

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
    collectionId: ApolloGQL.BigInt? = nil,
    collection: Collection? = nil,
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
        "searchableText": searchableText,
        "subPieceCount": subPieceCount,
        "userId": userId,
        "collectionId": collectionId,
        "collection": collection._fieldData,
        "catalogueNumber": catalogueNumber,
        "nickname": nickname,
        "composerId": composerId,
        "composer": composer._fieldData,
        "movements": movements._fieldData,
      ],
      fulfilledFragments: [
        ObjectIdentifier(PieceDetails.self)
      ]
    ))
  }

  /// Collection
  ///
  /// Parent Type: `Collections`
  public struct Collection: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Collections }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("name", String.self),
    ] }

    public var name: String { __data["name"] }

    public init(
      name: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Collections.typename,
          "name": name,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PieceDetails.Collection.self)
        ]
      ))
    }
  }

  /// Composer
  ///
  /// Parent Type: `Composers`
  public struct Composer: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Composers }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", ApolloGQL.BigInt.self),
      .field("userId", ApolloGQL.UUID?.self),
      .field("firstName", String.self),
      .field("lastName", String.self),
      .field("nationality", String?.self),
      .field("musicalEra", String?.self),
    ] }

    public var id: ApolloGQL.BigInt { __data["id"] }
    public var userId: ApolloGQL.UUID? { __data["userId"] }
    public var firstName: String { __data["firstName"] }
    public var lastName: String { __data["lastName"] }
    public var nationality: String? { __data["nationality"] }
    public var musicalEra: String? { __data["musicalEra"] }

    public init(
      id: ApolloGQL.BigInt,
      userId: ApolloGQL.UUID? = nil,
      firstName: String,
      lastName: String,
      nationality: String? = nil,
      musicalEra: String? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Composers.typename,
          "id": id,
          "userId": userId,
          "firstName": firstName,
          "lastName": lastName,
          "nationality": nationality,
          "musicalEra": musicalEra,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PieceDetails.Composer.self)
        ]
      ))
    }
  }

  /// Movements
  ///
  /// Parent Type: `MovementConnection`
  public struct Movements: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementConnection }
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
          "__typename": ApolloGQL.Objects.MovementConnection.typename,
          "edges": edges._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PieceDetails.Movements.self)
        ]
      ))
    }

    /// Movements.Edge
    ///
    /// Parent Type: `MovementEdge`
    public struct Edge: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementEdge }
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
            "__typename": ApolloGQL.Objects.MovementEdge.typename,
            "node": node._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(PieceDetails.Movements.Edge.self)
          ]
        ))
      }

      /// Movements.Edge.Node
      ///
      /// Parent Type: `Movement`
      public struct Node: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Movement }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ApolloGQL.BigInt.self),
          .field("lastPracticed", ApolloGQL.Datetime?.self),
          .field("totalPracticeTime", Int?.self),
          .field("name", String?.self),
          .field("keySignature", GraphQLEnum<ApolloGQL.KeySignatureType>?.self),
          .field("nickname", String?.self),
          .field("downloadUrl", String?.self),
          .field("pieceId", ApolloGQL.BigInt.self),
          .field("number", Int?.self),
        ] }

        public var id: ApolloGQL.BigInt { __data["id"] }
        public var lastPracticed: ApolloGQL.Datetime? { __data["lastPracticed"] }
        public var totalPracticeTime: Int? { __data["totalPracticeTime"] }
        public var name: String? { __data["name"] }
        public var keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? { __data["keySignature"] }
        public var nickname: String? { __data["nickname"] }
        public var downloadUrl: String? { __data["downloadUrl"] }
        public var pieceId: ApolloGQL.BigInt { __data["pieceId"] }
        public var number: Int? { __data["number"] }

        public init(
          id: ApolloGQL.BigInt,
          lastPracticed: ApolloGQL.Datetime? = nil,
          totalPracticeTime: Int? = nil,
          name: String? = nil,
          keySignature: GraphQLEnum<ApolloGQL.KeySignatureType>? = nil,
          nickname: String? = nil,
          downloadUrl: String? = nil,
          pieceId: ApolloGQL.BigInt,
          number: Int? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": ApolloGQL.Objects.Movement.typename,
              "id": id,
              "lastPracticed": lastPracticed,
              "totalPracticeTime": totalPracticeTime,
              "name": name,
              "keySignature": keySignature,
              "nickname": nickname,
              "downloadUrl": downloadUrl,
              "pieceId": pieceId,
              "number": number,
            ],
            fulfilledFragments: [
              ObjectIdentifier(PieceDetails.Movements.Edge.Node.self)
            ]
          ))
        }
      }
    }
  }
}
