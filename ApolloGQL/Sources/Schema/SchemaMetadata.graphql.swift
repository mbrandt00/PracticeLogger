// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

public protocol SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == ApolloGQL.SchemaMetadata {}

public protocol InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == ApolloGQL.SchemaMetadata {}

public protocol MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == ApolloGQL.SchemaMetadata {}

public protocol MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == ApolloGQL.SchemaMetadata {}

public enum SchemaMetadata: ApolloAPI.SchemaMetadata {
  public static let configuration: any ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

  public static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
    switch typename {
    case "Query": return ApolloGQL.Objects.Query
    case "PracticeSessionsConnection": return ApolloGQL.Objects.PracticeSessionsConnection
    case "PracticeSessionsEdge": return ApolloGQL.Objects.PracticeSessionsEdge
    case "PracticeSessions": return ApolloGQL.Objects.PracticeSessions
    case "Composers": return ApolloGQL.Objects.Composers
    case "Movements": return ApolloGQL.Objects.Movements
    case "Pieces": return ApolloGQL.Objects.Pieces
    case "Mutation": return ApolloGQL.Objects.Mutation
    case "PiecesInsertResponse": return ApolloGQL.Objects.PiecesInsertResponse
    default: return nil
    }
  }
}

public enum Objects {}
public enum Interfaces {}
public enum Unions {}
