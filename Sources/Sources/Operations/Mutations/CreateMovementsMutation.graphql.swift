// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

public class CreateMovementsMutation: GraphQLMutation {
    public static let operationName: String = "CreateMovementsMutation"
    public static let operationDocument: ApolloAPI.OperationDocument = .init(
        definition: .init(
            #"mutation CreateMovementsMutation($input: [MovementsInsertInput!]!) { insertIntoMovementsCollection(objects: $input) { __typename records { __typename number name id } } }"#
        ))

    public var input: [MovementsInsertInput]

    public init(input: [MovementsInsertInput]) {
        self.input = input
    }

    public var __variables: Variables? { ["input": input] }

    public struct Data: ApolloGQL.SelectionSet {
        public let __data: DataDict
        public init(_dataDict: DataDict) { __data = _dataDict }

        public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Mutation }
        public static var __selections: [ApolloAPI.Selection] { [
            .field("insertIntoMovementsCollection", InsertIntoMovementsCollection?.self, arguments: ["objects": .variable("input")]),
        ] }

        /// Adds one or more `Movements` records to the collection
        public var insertIntoMovementsCollection: InsertIntoMovementsCollection? { __data["insertIntoMovementsCollection"] }

        /// InsertIntoMovementsCollection
        ///
        /// Parent Type: `MovementsInsertResponse`
        public struct InsertIntoMovementsCollection: ApolloGQL.SelectionSet {
            public let __data: DataDict
            public init(_dataDict: DataDict) { __data = _dataDict }

            public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.MovementsInsertResponse }
            public static var __selections: [ApolloAPI.Selection] { [
                .field("__typename", String.self),
                .field("records", [Record].self),
            ] }

            /// Array of records impacted by the mutation
            public var records: [Record] { __data["records"] }

            /// InsertIntoMovementsCollection.Record
            ///
            /// Parent Type: `Movements`
            public struct Record: ApolloGQL.SelectionSet {
                public let __data: DataDict
                public init(_dataDict: DataDict) { __data = _dataDict }

                public static var __parentType: any ApolloAPI.ParentType { ApolloGQL.Objects.Movements }
                public static var __selections: [ApolloAPI.Selection] { [
                    .field("__typename", String.self),
                    .field("number", Int?.self),
                    .field("name", String?.self),
                    .field("id", ApolloGQL.BigInt.self),
                ] }

                public var number: Int? { __data["number"] }
                public var name: String? { __data["name"] }
                public var id: ApolloGQL.BigInt { __data["id"] }
            }
        }
    }
}
