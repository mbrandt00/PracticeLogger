// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PieceDetails: ApolloGQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PieceDetails on Piece { __typename imslpPieceId: id lastPracticed totalPracticeTime id workName catalogueType keySignature format instrumentation wikipediaUrl imslpUrl compositionYear catalogueNumberSecondary catalogueTypeNumDesc compositionYearDesc compositionYearString pieceStyle totalPracticeTime subPieceType subPieceCount catalogueNumber nickname composerId composer { __typename name } movements: movementCollection(orderBy: [{ number: AscNullsLast }]) { __typename edges { __typename node { __typename id lastPracticed totalPracticeTime name totalPracticeTime keySignature nickname downloadUrl pieceId number } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Piece }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", alias: "imslpPieceId", ApolloGQL.BigInt.self),
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
    .field("subPieceCount", Int?.self),
    .field("catalogueNumber", Int?.self),
    .field("nickname", String?.self),
    .field("composerId", ApolloGQL.BigInt?.self),
    .field("composer", Composer?.self),
    .field("movementCollection", alias: "movements", Movements?.self, arguments: ["orderBy": [["number": "AscNullsLast"]]]),
  ] }

  public var imslpPieceId: ApolloGQL.BigInt { __data["imslpPieceId"] }
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
  public var catalogueNumber: Int? { __data["catalogueNumber"] }
  public var nickname: String? { __data["nickname"] }
  public var composerId: ApolloGQL.BigInt? { __data["composerId"] }
  public var composer: Composer? { __data["composer"] }
  public var movements: Movements? { __data["movements"] }

  public init(
    imslpPieceId: ApolloGQL.BigInt,
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
    catalogueNumber: Int? = nil,
    nickname: String? = nil,
    composerId: ApolloGQL.BigInt? = nil,
    composer: Composer? = nil,
    movements: Movements? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": ApolloGQL.Objects.Piece.typename,
        "imslpPieceId": imslpPieceId,
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

  /// Composer
  ///
  /// Parent Type: `Composers`
  public struct Composer: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Composers }
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
          "__typename": ApolloGQL.Objects.Composers.typename,
          "name": name,
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
