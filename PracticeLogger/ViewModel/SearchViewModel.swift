//
//  SearchViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import ApolloGQL
import Combine
import Foundation

class SearchViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var selectedKeySignature: KeySignatureType?
    @Published var selectedPiece: ImslpPieceDetails? = nil
    @Published var userPieces: [PieceDetails] = []
    @Published var newPieces: [ImslpPieceDetails] = []

    @MainActor
    func searchPieces() async {
        do {
            if !searchTerm.isEmpty {
                newPieces = try await searchImslpPieces() ?? []
                userPieces = try await getUserPieces() ?? []
            }
        } catch {
            print("Error fetching pieces: \(error)")
        }
    }

    func getUserPieces() async throws -> [PieceDetails]? {
        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: SearchUserPiecesQuery(query: searchTerm)) { result in
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
            Network.shared.apollo.fetch(query: SearchImslpPiecesQuery(query: searchTerm, filterUserPieces: true)) { result in
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
