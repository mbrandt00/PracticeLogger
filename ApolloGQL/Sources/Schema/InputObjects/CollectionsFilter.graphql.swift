// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CollectionsFilter: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<BigIntFilter> = nil,
    name: GraphQLNullable<StringFilter> = nil,
    url: GraphQLNullable<StringFilter> = nil,
    composerId: GraphQLNullable<BigIntFilter> = nil,
    searchableText: GraphQLNullable<StringFilter> = nil,
    searchable: GraphQLNullable<BooleanFilter> = nil,
    userId: GraphQLNullable<UUIDFilter> = nil,
    nodeId: GraphQLNullable<IDFilter> = nil,
    and: GraphQLNullable<[CollectionsFilter]> = nil,
    or: GraphQLNullable<[CollectionsFilter]> = nil,
    not: GraphQLNullable<CollectionsFilter> = nil
  ) {
    __data = InputDict([
      "id": id,
      "name": name,
      "url": url,
      "composerId": composerId,
      "searchableText": searchableText,
      "searchable": searchable,
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

  public var name: GraphQLNullable<StringFilter> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var url: GraphQLNullable<StringFilter> {
    get { __data["url"] }
    set { __data["url"] = newValue }
  }

  public var composerId: GraphQLNullable<BigIntFilter> {
    get { __data["composerId"] }
    set { __data["composerId"] = newValue }
  }

  public var searchableText: GraphQLNullable<StringFilter> {
    get { __data["searchableText"] }
    set { __data["searchableText"] = newValue }
  }

  public var searchable: GraphQLNullable<BooleanFilter> {
    get { __data["searchable"] }
    set { __data["searchable"] = newValue }
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
  public var and: GraphQLNullable<[CollectionsFilter]> {
    get { __data["and"] }
    set { __data["and"] = newValue }
  }

  /// Returns true if at least one of its inner filters is true, otherwise returns false
  public var or: GraphQLNullable<[CollectionsFilter]> {
    get { __data["or"] }
    set { __data["or"] = newValue }
  }

  /// Negates a filter
  public var not: GraphQLNullable<CollectionsFilter> {
    get { __data["not"] }
    set { __data["not"] = newValue }
  }
}
