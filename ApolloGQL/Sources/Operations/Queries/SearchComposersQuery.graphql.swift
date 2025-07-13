// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class SearchComposersQuery: GraphQLQuery {
  public static let operationName: String = "SearchComposers"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query SearchComposers($query: String!, $composersFilter: ComposersFilter = {  }, $composersOrderBy: [ComposersOrderBy!] = []) { searchComposers( query: $query filter: $composersFilter orderBy: $composersOrderBy ) { __typename edges { __typename node { __typename id lastName firstName nationality } } } }"#
    ))

  public var query: String
  public var composersFilter: GraphQLNullable<ComposersFilter>
  public var composersOrderBy: GraphQLNullable<[ComposersOrderBy]>

  public init(
    query: String,
    composersFilter: GraphQLNullable<ComposersFilter> = .init(
      ComposersFilter()
    ),
    composersOrderBy: GraphQLNullable<[ComposersOrderBy]> = []
  ) {
    self.query = query
    self.composersFilter = composersFilter
    self.composersOrderBy = composersOrderBy
  }

  public var __variables: Variables? { [
    "query": query,
    "composersFilter": composersFilter,
    "composersOrderBy": composersOrderBy
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("searchComposers", SearchComposers?.self, arguments: [
        "query": .variable("query"),
        "filter": .variable("composersFilter"),
        "orderBy": .variable("composersOrderBy")
      ]),
    ] }

    public var searchComposers: SearchComposers? { __data["searchComposers"] }

    public init(
      searchComposers: SearchComposers? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "searchComposers": searchComposers._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(SearchComposersQuery.Data.self)
        ]
      ))
    }

    /// SearchComposers
    ///
    /// Parent Type: `ComposersConnection`
    public struct SearchComposers: ApolloGQL.SelectionSet {
      public let __data: DataDict
      public init(_dataDict: DataDict) { __data = _dataDict }

      public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.ComposersConnection }
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
            "__typename": ApolloGQL.Objects.ComposersConnection.typename,
            "edges": edges._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(SearchComposersQuery.Data.SearchComposers.self)
          ]
        ))
      }

      /// SearchComposers.Edge
      ///
      /// Parent Type: `ComposersEdge`
      public struct Edge: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.ComposersEdge }
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
              "__typename": ApolloGQL.Objects.ComposersEdge.typename,
              "node": node._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(SearchComposersQuery.Data.SearchComposers.Edge.self)
            ]
          ))
        }

        /// SearchComposers.Edge.Node
        ///
        /// Parent Type: `Composers`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Composers }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ApolloGQL.BigInt.self),
            .field("lastName", String.self),
            .field("firstName", String.self),
            .field("nationality", String?.self),
          ] }

          public var id: ApolloGQL.BigInt { __data["id"] }
          public var lastName: String { __data["lastName"] }
          public var firstName: String { __data["firstName"] }
          public var nationality: String? { __data["nationality"] }

          public init(
            id: ApolloGQL.BigInt,
            lastName: String,
            firstName: String,
            nationality: String? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.Composers.typename,
                "id": id,
                "lastName": lastName,
                "firstName": firstName,
                "nationality": nationality,
              ],
              fulfilledFragments: [
                ObjectIdentifier(SearchComposersQuery.Data.SearchComposers.Edge.Node.self)
              ]
            ))
          }
        }
      }
    }
  }
}
