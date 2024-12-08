// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PracticeSessionDetails: ApolloGQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PracticeSessionDetails on PracticeSessions { __typename id startTime endTime movement { __typename id name number } piece { __typename ...PieceDetails } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.PracticeSessions }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ApolloGQL.BigInt.self),
    .field("startTime", ApolloGQL.Datetime.self),
    .field("endTime", ApolloGQL.Datetime?.self),
    .field("movement", Movement?.self),
    .field("piece", Piece.self),
  ] }

  public var id: ApolloGQL.BigInt { __data["id"] }
  public var startTime: ApolloGQL.Datetime { __data["startTime"] }
  public var endTime: ApolloGQL.Datetime? { __data["endTime"] }
  public var movement: Movement? { __data["movement"] }
  public var piece: Piece { __data["piece"] }

  public init(
    id: ApolloGQL.BigInt,
    startTime: ApolloGQL.Datetime,
    endTime: ApolloGQL.Datetime? = nil,
    movement: Movement? = nil,
    piece: Piece
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": ApolloGQL.Objects.PracticeSessions.typename,
        "id": id,
        "startTime": startTime,
        "endTime": endTime,
        "movement": movement._fieldData,
        "piece": piece._fieldData,
      ],
      fulfilledFragments: [
        ObjectIdentifier(PracticeSessionDetails.self)
      ]
    ))
  }

  /// Movement
  ///
  /// Parent Type: `Movements`
  public struct Movement: ApolloGQL.SelectionSet {
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
          ObjectIdentifier(PracticeSessionDetails.Movement.self)
        ]
      ))
    }
  }

  /// Piece
  ///
  /// Parent Type: `Pieces`
  public struct Piece: ApolloGQL.SelectionSet {
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
          "catalogueNumber": catalogueNumber,
          "nickname": nickname,
          "composer": composer._fieldData,
          "movements": movements._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PracticeSessionDetails.Piece.self),
          ObjectIdentifier(PieceDetails.self)
        ]
      ))
    }

    public typealias Composer = PieceDetails.Composer

    public typealias Movements = PieceDetails.Movements
  }
}
