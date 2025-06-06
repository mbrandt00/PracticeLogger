//
//  SearchViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Apollo
import ApolloAPI
import ApolloGQL
import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var userPieces: [PieceDetails] = []
    @Published var newPieces: [PieceDetails] = []
    @Published var selectedPiece: PieceDetails?

    @MainActor
    func searchPieces() async {
        do {
            if !searchTerm.isEmpty {
                userPieces = try await getUserPieces() ?? []
                newPieces = try await searchNewPieces() ?? []
            } else {
                userPieces = try await getRecentUserPieces(forceFetch: true) ?? []
                newPieces = []
            }
        } catch {
            print("Error fetching pieces: \(error)")
        }
    }

    func getRecentUserPieces(forceFetch: Bool = false) async throws -> [PieceDetails]? {
        guard let userId = Database.client.auth.currentUser?.id else {
            return nil
        }

        return try await withCheckedThrowingContinuation { continuation in
            let filter = PieceFilter(userId: .some(UUIDFilter(eq: .some(userId.uuidString))))
            let direction = GraphQLEnum(OrderByDirection.descNullsFirst)
            let orderBy: GraphQLNullable<[PieceOrderBy]> = .some([PieceOrderBy(lastPracticed: .some(direction))])

            let fetchPolicy: CachePolicy = forceFetch ? .fetchIgnoringCacheData : .returnCacheDataElseFetch

            Network.shared.apollo.fetch(
                query: PiecesQuery(pieceFilter: filter, orderBy: orderBy),
                cachePolicy: fetchPolicy
            ) { result in
                switch result {
                case let .success(graphQlResult):
                    if let data = graphQlResult.data?.pieceCollection {
                        let pieces = data.edges.map { edge in
                            edge.node.fragments.pieceDetails
                        }
                        continuation.resume(returning: pieces)
                    } else {
                        continuation.resume(returning: nil)
                    }

                case let .failure(error):
                    print("Error fetching recent pieces: \(error)")
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func getUserPieces() async throws -> [PieceDetails]? {
        guard let userId = Database.client.auth.currentUser?.id else {
            return []
        }
        return try await withCheckedThrowingContinuation { continuation in
            let direction = GraphQLEnum(OrderByDirection.descNullsFirst)
            let orderBy: GraphQLNullable<[PieceOrderBy]> = .some([PieceOrderBy(lastPracticed: .some(direction))])
            let filter = GraphQLNullable(PieceFilter(
                userId: .some(UUIDFilter(eq: .some(userId.uuidString)))
            ))
            Network.shared.apollo.fetch(query: SearchPiecesQuery(query: searchTerm, pieceFilter: filter, orderBy: orderBy)) { result in
                switch result {
                case let .success(graphQlResult):
                    if let data = graphQlResult.data?.searchPieces {
                        let pieces = data.edges.map { edge in
                            edge.node.fragments.pieceDetails
                        }
                        continuation.resume(returning: pieces)
                    } else {
                        continuation.resume(returning: nil)
                    }

                case let .failure(error):
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func searchNewPieces() async throws -> [PieceDetails]? {
        guard (Database.client.auth.currentUser?.id) != nil else {
            return []
        }
        let userPieceUrls = Set(userPieces.compactMap { $0.imslpUrl })

        return try await withCheckedThrowingContinuation { continuation in
            let direction = GraphQLEnum(OrderByDirection.ascNullsLast)
            let orderBy: GraphQLNullable<[PieceOrderBy]> = .some([PieceOrderBy(catalogueNumber: .some(direction))])
            Network.shared.apollo.fetch(query: SearchPiecesQuery(query: searchTerm, orderBy: orderBy)) { result in
                switch result {
                case let .success(graphQlResult):
                    if let data = graphQlResult.data?.searchPieces {
                        let pieces = data.edges.map { edge in
                            edge.node.fragments.pieceDetails
                        }.filter { piece in
                            // Filter out pieces the user already has
                            guard let imslpUrl = piece.imslpUrl else { return true }
                            return !userPieceUrls.contains(imslpUrl)
                        }
                        continuation.resume(returning: pieces)
                    } else {
                        continuation.resume(returning: [])
                    }

                case let .failure(error):
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
