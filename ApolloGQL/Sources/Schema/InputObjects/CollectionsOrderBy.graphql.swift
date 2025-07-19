// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public struct CollectionsOrderBy: InputObject {
  public private(set) var __data: InputDict

  public init(_ data: InputDict) {
    __data = data
  }

  public init(
    id: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    name: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    url: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    composerId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    searchableText: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    searchable: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil,
    userId: GraphQLNullable<GraphQLEnum<OrderByDirection>> = nil
  ) {
    __data = InputDict([
      "id": id,
      "name": name,
      "url": url,
      "composerId": composerId,
      "searchableText": searchableText,
      "searchable": searchable,
      "userId": userId
    ])
  }

  public var id: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["id"] }
    set { __data["id"] = newValue }
  }

  public var name: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["name"] }
    set { __data["name"] = newValue }
  }

  public var url: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["url"] }
    set { __data["url"] = newValue }
  }

  public var composerId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["composerId"] }
    set { __data["composerId"] = newValue }
  }

  public var searchableText: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["searchableText"] }
    set { __data["searchableText"] = newValue }
  }

  public var searchable: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["searchable"] }
    set { __data["searchable"] = newValue }
  }

  public var userId: GraphQLNullable<GraphQLEnum<OrderByDirection>> {
    get { __data["userId"] }
    set { __data["userId"] = newValue }
  }
}
