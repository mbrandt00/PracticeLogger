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
    @Published var selectedKeySignature: KeySignatureType?
    @Published var userPieces: [PieceDetails] = []
    @Published var newPieces: [PieceDetails] = []
    @Published var selectedPiece: PieceDetails?
    @MainActor
    func searchPieces() async {
        do {
            if !searchTerm.isEmpty {
                // First get the user's pieces
                userPieces = try await getUserPieces() ?? []

                // Then get the new pieces
                var allNewPieces = try await searchNewPieces() ?? []

                // Create a set of IMSLP URLs that the user already has
                let userImslpUrls = Set(userPieces.compactMap { piece in
                    // We want to collect imslpUrl values from user pieces that aren't IMSLP pieces themselves
                    // but reference IMSLP pieces
                    if let isImslp = piece.isImslp, !isImslp {
                        return piece.imslpUrl
                    }
                    return nil
                })

                // Filter out pieces that the user already has
                newPieces = allNewPieces.filter { piece in
                    // Keep the piece only if its imslpUrl is not in the user's pieces
                    if let imslpUrl = piece.imslpUrl {
                        return !userImslpUrls.contains(imslpUrl)
                    }
                    // If the piece doesn't have an imslpUrl, keep it
                    return true
                }

                print("new Pieces", newPieces)
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
                case .success(let graphQlResult):
                    if let data = graphQlResult.data?.pieceCollection {
                        let pieces = data.edges.map { edge in
                            edge.node.fragments.pieceDetails
                        }
                        continuation.resume(returning: pieces)
                    } else {
                        continuation.resume(returning: nil)
                    }
                case .failure(let error):
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
                case .success(let graphQlResult):
                    if let data = graphQlResult.data?.searchPieces {
                        let pieces = data.edges.map { edge in
                            edge.node.fragments.pieceDetails
                        }
                        print("user pieces", pieces)
                        continuation.resume(returning: pieces)
                    } else {
                        continuation.resume(returning: nil)
                    }
                case .failure(let error):
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func searchNewPieces() async throws -> [PieceDetails]? {
        guard let userId = Database.client.auth.currentUser?.id else {
            return []
        }
        return try await withCheckedThrowingContinuation { continuation in
            let direction = GraphQLEnum(OrderByDirection.descNullsFirst)
            let orderBy: GraphQLNullable<[PieceOrderBy]> = .some([PieceOrderBy(lastPracticed: .some(direction))])
            let filter = GraphQLNullable(PieceFilter(
                isImslp: .some(BooleanFilter(eq: .some(true)))
            ))
            Network.shared.apollo.fetch(query: SearchPiecesQuery(query: searchTerm, pieceFilter: filter)) { result in
                switch result {
                case .success(let graphQlResult):
                    if let data = graphQlResult.data?.searchPieces {
                        let pieces = data.edges.map { edge in
                            edge.node.fragments.pieceDetails
                        }
                        print("NEW PIECES", pieces)
                        continuation.resume(returning: pieces)
                    } else {
                        continuation.resume(returning: [])
                    }
                case .failure(let error):
                    print(error)
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
