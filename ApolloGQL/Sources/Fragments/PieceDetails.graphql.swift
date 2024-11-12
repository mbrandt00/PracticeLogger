// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct PieceDetails: ApolloGQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment PieceDetails on Pieces { __typename id workName catalogueType catalogueNumber nickname composer { __typename name } movements: movementsCollection(orderBy: [{ number: DescNullsLast }]) { __typename edges { __typename node { __typename id name number } } } }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Pieces }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ApolloGQL.BigInt.self),
    .field("workName", String.self),
    .field("catalogueType", GraphQLEnum<ApolloGQL.CatalogueType>?.self),
    .field("catalogueNumber", Int?.self),
    .field("nickname", String?.self),
    .field("composer", Composer?.self),
    .field("movementsCollection", alias: "movements", Movements?.self, arguments: ["orderBy": [["number": "DescNullsLast"]]]),
  ] }

  public var id: ApolloGQL.BigInt { __data["id"] }
  public var workName: String { __data["workName"] }
  public var catalogueType: GraphQLEnum<ApolloGQL.CatalogueType>? { __data["catalogueType"] }
  public var catalogueNumber: Int? { __data["catalogueNumber"] }
  public var nickname: String? { __data["nickname"] }
  public var composer: Composer? { __data["composer"] }
  public var movements: Movements? { __data["movements"] }

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
      }
    }
  }
}
