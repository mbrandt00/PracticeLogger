//
//  SearchViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import Apollo
import ApolloGQL
import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var userPieces: [PieceDetails] = []
    @Published var newPieces: [PieceDetails] = []
    @Published var allUserPieces: [PieceDetails] = []
    @Published var selectedPiece: PieceDetails?
    private var indexedUserPieces: [IndexedPiece] = []

    @MainActor
    func searchPieces() async {
        do {
            if !searchTerm.isEmpty {
                userPieces = await matchingUserPieces()
                newPieces = try await searchNewPieces() ?? []
            } else {
                let fresh = try await getRecentUserPieces() ?? []
                allUserPieces = fresh
                indexedUserPieces = fresh.map { IndexedPiece($0) }
                userPieces = fresh
                newPieces = []
            }
        } catch {
            print("Error fetching pieces: \(error)")
        }
    }

    func matchingUserPieces() async -> [PieceDetails] {
        let searchTerms = searchTerm.lowercased().split(separator: " ")

        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let matches = self.indexedUserPieces.filter { indexed in
                    searchTerms.allSatisfy { term in
                        indexed.normalizedWords.contains { $0.hasPrefix(term) }
                    }
                }.map { $0.piece }

                continuation.resume(returning: matches)
            }
        }
    }

    func getRecentUserPieces() async throws -> [PieceDetails]? {
        guard let userId = Database.client.auth.currentUser?.id else {
            return nil
        }

        return try await withCheckedThrowingContinuation { continuation in
            let filter = PieceFilter(userId: .some(UUIDFilter(eq: .some(userId.uuidString))))
            let direction = GraphQLEnum(OrderByDirection.descNullsFirst)
            let orderBy: GraphQLNullable<[PieceOrderBy]> = .some([PieceOrderBy(lastPracticed: .some(direction))])

            Network.shared.apollo.fetch(
                query: PiecesQuery(pieceFilter: filter, orderBy: orderBy),
                cachePolicy: .fetchIgnoringCacheData
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
        let userPieceUrls = Set(allUserPieces.compactMap { $0.imslpUrl })

        return try await withCheckedThrowingContinuation { continuation in
            let direction = GraphQLEnum(OrderByDirection.ascNullsLast)
            let orderBy: GraphQLNullable<[PieceOrderBy]> = .some([PieceOrderBy(catalogueNumber: .some(direction))])
            let filter: GraphQLNullable<PieceFilter> = .some(
                PieceFilter(imslpUrl: .some(StringFilter(is: .some(GraphQLEnum(.notNull))))) // seach should not return custom pieces from other users
            )

            Network.shared.apollo.fetch(query: SearchPiecesQuery(query: searchTerm, pieceFilter: filter, orderBy: orderBy)) { result in
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

struct IndexedPiece {
    let piece: PieceDetails
    let normalizedWords: [Substring]

    init(_ piece: PieceDetails) {
        self.piece = piece
        self.normalizedWords = piece.searchableText?.lowercased().split(separator: " ") ?? []
    }
}
