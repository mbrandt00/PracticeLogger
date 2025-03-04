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
    @Published var selectedKeySignature: KeySignatureType?
    @Published var selectedPiece: ImslpPieceDetails?
    @Published var userPieces: [PieceDetails] = []
    @Published var newPieces: [ImslpPieceDetails] = []

    @MainActor
    func searchPieces() async {
        do {
            if !searchTerm.isEmpty {
                newPieces = try await searchImslpPieces() ?? []
                print("new Pieces", newPieces)
                userPieces = try await getUserPieces() ?? []
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
        return try await withCheckedThrowingContinuation { continuation in
            let direction = GraphQLEnum(OrderByDirection.descNullsFirst)
            let orderBy: GraphQLNullable<[PieceOrderBy]> = .some([PieceOrderBy(lastPracticed: .some(direction))])
            Network.shared.apollo.fetch(query: SearchUserPiecesQuery(query: searchTerm, orderBy: orderBy)) { result in
                switch result {
                case .success(let graphQlResult):
                    if let data = graphQlResult.data?.searchUserPieces {
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

    func searchImslpPieces() async throws -> [ImslpPieceDetails]? {
        return try await withCheckedThrowingContinuation { continuation in
            let direction = GraphQLEnum(OrderByDirection.ascNullsFirst)
            let orderBy: GraphQLNullable<[ImslpPieceOrderBy]> = .some([ImslpPieceOrderBy(catalogueNumber: .some(direction))])

            Network.shared.apollo.fetch(query: SearchImslpPiecesQuery(query: searchTerm, filterUserPieces: true, orderBy: orderBy)) { result in
                switch result {
                case .success(let graphQlResult):
                    if let data = graphQlResult.data?.searchImslpPieces {
                        let pieces = data.edges.map { edge in
                            edge.node.fragments.imslpPieceDetails // make these conform together with protocol...
                        }
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
}

extension SearchImslpPiecesQuery.Data.SearchImslpPieces.Edge.Node: Identifiable {}
extension ImslpPieceDetails: Identifiable {}
