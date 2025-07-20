//
//  CollectionsViewModel.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/15/25.
//

import ApolloGQL
import Foundation

class CollectionsViewModel: ObservableObject {
    @Published var selectedPieces: [PieceDetails]?
    @Published var searchResults: [IndexedPiece]?
    @Published var searchTerm = ""

    func searchUserPieces() async throws {
        guard let userId = Database.client.auth.currentUser?.id else {
            self.selectedPieces = []
            return
        }

        // Step 1: Fetch matching pieces from GraphQL
        let pieces: [PieceDetails]? = try await withCheckedThrowingContinuation { continuation in
            let filter = GraphQLNullable(PieceFilter(
                userId: .some(UUIDFilter(eq: .some(userId.uuidString)))
            ))

            Network.shared.apollo.fetch(query: SearchPiecesQuery(query: self.searchTerm, pieceFilter: filter)) { result in
                switch result {
                case let .success(graphQlResult):
                    if let data = graphQlResult.data?.searchPieces {
                        let pieces = data.edges.map { $0.node.fragments.pieceDetails }
                        self.searchResults = pieces.map { IndexedPiece($0) }
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

        let filtered = await self.matchingUserPieces()
        DispatchQueue.main.async {
            self.selectedPieces = filtered
        }
    }

    private func matchingUserPieces() async -> [PieceDetails] {
        let searchTerms = self.searchTerm.lowercased().split(separator: " ")

        return await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let matches = self.searchResults?.filter { indexed in
                    searchTerms.allSatisfy { term in
                        indexed.normalizedWords.contains { $0.hasPrefix(term) }
                    }
                }.map { $0.piece }

                continuation.resume(returning: matches ?? [])
            }
        }
    }

    func saveNewCollection(collectionName: String) async throws -> Int {
        let userId = try await Database.client.auth.user().id.uuidString
        guard let selected = self.selectedPieces else {
            throw RuntimeError("No selected pieces")
        }

        let pieceIds = selected.map { Int($0.id) }

        let response: [String: Int] = try await Database.client
            .from("collections")
            .insert(CollectionInsertInput(name: collectionName, user_id: userId))
            .select("id")
            .single()
            .execute()
            .value

        guard let collectionId = response["id"] else { throw RuntimeError("Collection could not be created") }

        let collectionPiecesInput = pieceIds.map { pieceId in
            CollectionPiecesInput(collection_id: collectionId, piece_id: pieceId!)
        }

        try await Database.client
            .from("collection_pieces")
            .insert(collectionPiecesInput)
            .execute()
        return collectionId
    }

    struct CollectionInsertInput: Codable {
        let name: String
        let user_id: String
    }

    struct CollectionPiecesInput: Codable {
        let collection_id: Int
        let piece_id: Int
    }
}
