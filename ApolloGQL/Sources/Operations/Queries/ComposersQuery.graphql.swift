// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class ComposersQuery: GraphQLQuery {
  public static let operationName: String = "ComposersQuery"
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ComposersQuery($composerFilter: ComposersFilter = {  }, $orderBy: [ComposersOrderBy!] = []) { composersCollection(filter: $composerFilter, orderBy: $orderBy) { __typename edges { __typename node { __typename id firstName lastName musicalEra nationality userId } } } }"#
    ))

  public var composerFilter: GraphQLNullable<ComposersFilter>
  public var orderBy: GraphQLNullable<[ComposersOrderBy]>

  public init(
    composerFilter: GraphQLNullable<ComposersFilter> = .init(
      ComposersFilter()
    ),
    orderBy: GraphQLNullable<[ComposersOrderBy]> = []
  ) {
    self.composerFilter = composerFilter
    self.orderBy = orderBy
  }

  public var __variables: Variables? { [
    "composerFilter": composerFilter,
    "orderBy": orderBy
  ] }

  public struct Data: ApolloGQL.SelectionSet {
    public let __data: DataDict
    public init(_dataDict: DataDict) { __data = _dataDict }

    public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Query }
    public static var __selections: [ApolloAPI.Selection] { [
      .field("composersCollection", ComposersCollection?.self, arguments: [
        "filter": .variable("composerFilter"),
        "orderBy": .variable("orderBy")
      ]),
    ] }

    /// A pagable collection of type `Composers`
    public var composersCollection: ComposersCollection? { __data["composersCollection"] }

    public init(
      composersCollection: ComposersCollection? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": ApolloGQL.Objects.Query.typename,
          "composersCollection": composersCollection._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ComposersQuery.Data.self)
        ]
      ))
    }

    /// ComposersCollection
    ///
    /// Parent Type: `ComposersConnection`
    public struct ComposersCollection: ApolloGQL.SelectionSet {
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
            ObjectIdentifier(ComposersQuery.Data.ComposersCollection.self)
          ]
        ))
      }

      /// ComposersCollection.Edge
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
              ObjectIdentifier(ComposersQuery.Data.ComposersCollection.Edge.self)
            ]
          ))
        }

        /// ComposersCollection.Edge.Node
        ///
        /// Parent Type: `Composers`
        public struct Node: ApolloGQL.SelectionSet {
          public let __data: DataDict
          public init(_dataDict: DataDict) { __data = _dataDict }

          public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Composers }
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", ApolloGQL.BigInt.self),
            .field("firstName", String.self),
            .field("lastName", String.self),
            .field("musicalEra", String?.self),
            .field("nationality", String?.self),
            .field("userId", ApolloGQL.UUID?.self),
          ] }

          public var id: ApolloGQL.BigInt { __data["id"] }
          public var firstName: String { __data["firstName"] }
          public var lastName: String { __data["lastName"] }
          public var musicalEra: String? { __data["musicalEra"] }
          public var nationality: String? { __data["nationality"] }
          public var userId: ApolloGQL.UUID? { __data["userId"] }

          public init(
            id: ApolloGQL.BigInt,
            firstName: String,
            lastName: String,
            musicalEra: String? = nil,
            nationality: String? = nil,
            userId: ApolloGQL.UUID? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": ApolloGQL.Objects.Composers.typename,
                "id": id,
                "firstName": firstName,
                "lastName": lastName,
                "musicalEra": musicalEra,
                "nationality": nationality,
                "userId": userId,
              ],
              fulfilledFragments: [
                ObjectIdentifier(ComposersQuery.Data.ComposersCollection.Edge.Node.self)
              ]
            ))
          }
        }
      }
    }
  }
}
