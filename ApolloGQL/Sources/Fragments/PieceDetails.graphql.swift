// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PieceDetails: ApolloGQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PieceDetails on Pieces { __typename id workName catalogueType keySignature format instrumentation wikipediaUrl imslpUrl compositionYear catalogueNumber nickname composer { __typename name } movements: movementsCollection(orderBy: [{ number: DescNullsLast }]) { __typename edges { __typename node { __typename id name number } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Pieces }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ApolloGQL.BigInt.self),
    .field("workName", String.self),
    .field("catalogueType", GraphQLEnum<ApolloGQL.CatalogueType>?.self),
    .field("keySignature", GraphQLEnum<ApolloGQL.KeySignatureType>?.self),
    .field("format", GraphQLEnum<ApolloGQL.PieceFormat>?.self),
    .field("instrumentation", [String?]?.self),
    .field("wikipediaUrl", String?.self),
    .field("imslpUrl", String?.self),
    .field("compositionYear", Int?.self),
    .field("catalogueNumber", Int?.self),
    .field("nickname", String?.self),
    .field("composer", Composer?.self),
    .field("movementsCollection", alias: "movements", Movements?.self, arguments: ["orderBy": [["number": "DescNullsLast"]]]),
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
  /// Parent Type: `MovementsConnection`
  public struct Movements: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementsConnection }
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
          "__typename": ApolloGQL.Objects.MovementsConnection.typename,
          "edges": edges._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PieceDetails.Movements.self)
        ]
      ))
    }

    /// Movements.Edge
    ///
    /// Parent Type: `MovementsEdge`
    public struct Edge: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementsEdge }
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
            "__typename": ApolloGQL.Objects.MovementsEdge.typename,
            "node": node._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(PieceDetails.Movements.Edge.self)
          ]
        ))
      }

      /// Movements.Edge.Node
      ///
      /// Parent Type: `Movements`
      public struct Node: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Movements }
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", ApolloGQL.BigInt.self),
          .field("name", String?.self),
          .field("number", Int?.self),
        ] }

        public var id: ApolloGQL.BigInt { __data["id"] }
        public var name: String? { __data["name"] }
        public var number: Int? { __data["number"] }

        public init(
          id: ApolloGQL.BigInt,
          name: String? = nil,
          number: Int? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": ApolloGQL.Objects.Movements.typename,
              "id": id,
              "name": name,
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
