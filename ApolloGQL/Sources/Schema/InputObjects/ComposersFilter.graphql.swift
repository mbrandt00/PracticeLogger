// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct ComposersFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<BigIntFilter> = nil,
    firstName: GraphQLNullable<StringFilter> = nil,
    lastName: GraphQLNullable<StringFilter> = nil,
    nationality: GraphQLNullable<StringFilter> = nil,
    musicalEra: GraphQLNullable<StringFilter> = nil,
    userId: GraphQLNullable<UUIDFilter> = nil,
    nodeId: GraphQLNullable<IDFilter> = nil,
    and: GraphQLNullable<[ComposersFilter]> = nil,
    or: GraphQLNullable<[ComposersFilter]> = nil,
    not: GraphQLNullable<ComposersFilter> = nil
  ) {
    __data = InputDict([
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "nationality": nationality,
      "musicalEra": musicalEra,
      "userId": userId,
      "nodeId": nodeId,
      "and": and,
      "or": or,
      "not": not
    ])
  }

  public var id: GraphQLNullable<BigIntFilter> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var firstName: GraphQLNullable<StringFilter> {
    get { __data["firstName"] }
    set { __data["firstName"] = newValue }
  }

  public var lastName: GraphQLNullable<StringFilter> {
    get { __data["lastName"] }
    set { __data["lastName"] = newValue }
  }

  public var nationality: GraphQLNullable<StringFilter> {
    get { __data["nationality"] }
    set { __data["nationality"] = newValue }
  }

  public var musicalEra: GraphQLNullable<StringFilter> {
    get { __data["musicalEra"] }
    set { __data["musicalEra"] = newValue }
  }

  public var userId: GraphQLNullable<UUIDFilter> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }

  public var nodeId: GraphQLNullable<IDFilter> {
    get { __data["nodeId"] }
    set { __data["nodeId"] = newValue }
  }

  /// Returns true only if all its inner filters are true, otherwise returns false
  public var and: GraphQLNullable<[ComposersFilter]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  /// Returns true if at least one of its inner filters is true, otherwise returns false
  public var or: GraphQLNullable<[ComposersFilter]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  /// Negates a filter
  public var not: GraphQLNullable<ComposersFilter> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }
}
