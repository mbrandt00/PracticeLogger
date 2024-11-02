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
    .field("id", ApolloGQL.UUID.self),
    .field("startTime", ApolloGQL.Datetime.self),
    .field("endTime", ApolloGQL.Datetime?.self),
    .field("movement", Movement?.self),
    .field("piece", Piece.self),
  ] }

  public var id: ApolloGQL.UUID { __data["id"] }
  public var startTime: ApolloGQL.Datetime { __data["startTime"] }
  public var endTime: ApolloGQL.Datetime? { __data["endTime"] }
  public var movement: Movement? { __data["movement"] }
  public var piece: Piece { __data["piece"] }

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

    public var id: ApolloGQL.UUID { __data["id"] }
    public var workName: String { __data["workName"] }
    public var composer: Composer? { __data["composer"] }
    public var movements: Movements? { __data["movements"] }

    public struct Fragments: FragmentContainer {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public var pieceDetails: PieceDetails { _toFragment() }
    }

    public typealias Composer = PieceDetails.Composer

    public typealias Movements = PieceDetails.Movements
  }
}
