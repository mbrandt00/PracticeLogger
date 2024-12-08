//
//  SearchViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/24.
//

import ApolloGQL
import Combine
import Foundation
import MusicKit

class SearchViewModel: ObservableObject {
    @Published var searchTerm = ""
    @Published var isFocused: Bool = false
    @Published var selectedKeySignature: KeySignatureType?
    @Published var userPieces: [PieceDetails] = []
    @Published var newPieces: [PieceDetails] = []
    private var cancellables = Set<AnyCancellable>()

    @MainActor
    func searchPieces() async {
        do {
            let status = await MusicAuthorization.request()
            switch status {
            case .authorized:
                do {
//                    userPieces = try await getUserPieces()
                    if !searchTerm.isEmpty {
                        newPieces = try await searchImslpPieces() ?? []
//                        let userPieceSet = Set(userPieces)
//                        fetchedPieces.removeAll { userPieceSet.contains($0) }
//                        if let selectedKeySignature = selectedKeySignature {
//                            fetchedPieces = fetchedPieces.filter { $0.key_signature == selectedKeySignature }
//                        }
//                        newPieces = fetchedPieces.filter { newPiece in
//                            !userPieces.contains { userPiece in
//                                newPiece.catalogue_type?.rawValue == userPiece.catalogueType?.rawValue &&
//                                    newPiece.catalogue_number == userPiece.catalogueNumber
//                            }
//                        }
                    }
                } catch {
                    print("Error fetching pieces: \(error)")
                }
            default:
                print("Unknown music authorization status.")
            }
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
    func searchImslpPieces() async throws -> [PieceDetails]? {
        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: SearchImslpPiecesQuery(query: searchTerm)) { result in
                switch result {
                case .success(let graphQlResult):
                    if let data = graphQlResult.data?.searchImslpPieces {
                        let pieces = data.edges.map { edge in
                            return edge.node.fragments.pieceDetails
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
