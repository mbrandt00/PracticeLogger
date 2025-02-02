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

//    @MainActor
//    func searchPieces() async {
//        do {
    ////                    userPieces = try await getUserPieces()
//                    if !searchTerm.isEmpty {
//                        newPieces = try await searchImslpPieces() ?? []
    ////                        let userPieceSet = Set(userPieces)
    ////                        fetchedPieces.removeAll { userPieceSet.contains($0) }
    ////                        if let selectedKeySignature = selectedKeySignature {
    ////                            fetchedPieces = fetchedPieces.filter { $0.key_signature == selectedKeySignature }
    ////                        }
    ////                        newPieces = fetchedPieces.filter { newPiece in
    ////                            !userPieces.contains { userPiece in
    ////                                newPiece.catalogue_type?.rawValue == userPiece.catalogueType?.rawValue &&
    ////                                    newPiece.catalogue_number == userPiece.catalogueNumber
    ////                            }
    ////                        }
//                    }catch {
//                    print("Error fetching pieces: \(error)")
//                }
//                }
//        }
//    }
    @MainActor
    func searchPieces() async {
        do {
            if !searchTerm.isEmpty {
                newPieces = try await searchImslpPieces() ?? []
            }
        } catch {
            print("Error fetching pieces: \(error)")
        }
    }

//    func getUserPieces() async throws -> [PieceDetails] {
//        let userId = try await Database.client.auth.user().id.uuidString
//
//        return try await withCheckedThrowingContinuation { continuation in
//            Network.shared.apollo.fetch(query: SearchPiecesQuery(query: searchTerm, pieceFilter: .some(PiecesFilter(userId: .some(UUIDFilter(eq: .some(userId))))))) { result in
//                switch result {
//                case .success(let graphQlResult):
//                    if let pieces = graphQlResult.data?.searchPieceWithAssociations?.edges {
//                        let nodes = pieces.compactMap { $0.node.fragments.pieceDetails }
//                        continuation.resume(returning: nodes)
//                    } else {
//                        continuation.resume(returning: [])
//                    }
//                case .failure(let error):
//                    print("GraphQL query failed: \(error)")
//                    continuation.resume(throwing: error)
//                }
//            }
//        }
//    }
    func searchImslpPieces() async throws -> [ImslpPieceDetails]? {
        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: SearchImslpPiecesQuery(query: searchTerm, filterUserPieces: true)) { result in
                switch result {
                case .success(let graphQlResult):
                    if let data = graphQlResult.data?.searchImslpPieces {
                        print(data)
                        let pieces = data.edges.map { edge in
                            edge.node.fragments.imslpPieceDetails // make these conform together with protocol...
                        }
                        print("pieces", pieces)
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
