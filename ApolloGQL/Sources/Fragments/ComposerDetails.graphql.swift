// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public struct ComposerDetails: ApolloGQL.SelectionSet, Fragment {
  public static var fragmentDefinition: StaticString {
    #"fragment ComposerDetails on Composers { __typename id firstName lastName }"#
  }

  public let __data: DataDict
  public init(_dataDict: DataDict) { __data = _dataDict }

  public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Composers }
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", ApolloGQL.BigInt.self),
    .field("firstName", String.self),
    .field("lastName", String.self),
  ] }

  public var id: ApolloGQL.BigInt { __data["id"] }
  public var firstName: String { __data["firstName"] }
  public var lastName: String { __data["lastName"] }

  public init(
    id: ApolloGQL.BigInt,
    firstName: String,
    lastName: String
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": ApolloGQL.Objects.Composers.typename,
        "id": id,
        "firstName": firstName,
        "lastName": lastName,
      ],
      fulfilledFragments: [
        ObjectIdentifier(ComposerDetails.self)
      ]
    ))
  }
}
