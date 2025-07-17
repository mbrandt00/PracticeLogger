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
    enum SearchFilter: String, CaseIterable, Identifiable {
        case all = "All" // eventual meilisearch multi index search
        case userPieces = "Library"
        case discover = "Discover"
        case composers = "Composers"
        case collections = "Collections"

        var id: Self { self }
    }

    var availableFilters: [SearchFilter] {
        if searchTerm.isEmpty {
            return SearchFilter.allCases.filter { $0 != .discover }
        } else {
            return SearchFilter.allCases
        }
    }

    struct ComposerType: Identifiable, Equatable, Hashable {
        let firstName: String
        let lastName: String
        let nationality: String?
        let id: String?

        static func from(_ composer: EditableComposer) -> ComposerType {
            .init(
                firstName: composer.firstName,
                lastName: composer.lastName,
                nationality: composer.nationality,
                id: composer.id
            )
        }

        static func == (lhs: ComposerType, rhs: ComposerType) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    @Published var searchTerm = ""
    @Published var userPieces: [PieceDetails] = []
    @Published var newPieces: [PieceDetails] = []
    @Published var allUserPieces: [PieceDetails] = []
    @Published var selectedPiece: PieceDetails?
    @Published var searchFilter: SearchFilter = .all
    @Published var collections: [CollectionGroup] = []
    @Published var composers: [ComposerType] = []
    private var indexedUserPieces: [IndexedPiece] = []

    struct CollectionGroup: Identifiable, Equatable, Hashable {
        let id: String
        let name: String
        let composer: SearchCollectionsQuery.Data.SearchCollections.Edge.Node.Composer?
        let pieces: [PieceDetails]

        static func == (lhs: CollectionGroup, rhs: CollectionGroup) -> Bool {
            lhs.id == rhs.id
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
    }

    @MainActor
    func searchPieces() async {
        do {
            if !searchTerm.isEmpty {
                userPieces = await matchingUserPieces()
                newPieces = try await searchNewPieces() ?? []
                collections = try await searchCollections() ?? []
                composers = try await searchComposers() ?? []
                print(collections)
            } else {
                let fresh = try await getRecentUserPieces() ?? []
                allUserPieces = fresh
                indexedUserPieces = fresh.map { IndexedPiece($0) }
                userPieces = fresh
                composers = try await fetchAllComposers()
                collections = []
                newPieces = []
            }
        } catch {
            print("Error fetching pieces: \(error)")
        }
    }

    func searchCollections() async throws -> [CollectionGroup]? {
        try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(
                query: SearchCollectionsQuery(query: searchTerm),
                cachePolicy: .returnCacheDataElseFetch
            ) { result in
                switch result {
                case let .success(graphQlResult):
                    if let data = graphQlResult.data?.searchCollections {
                        let groups = data.edges.map { edge in
                            let collectionName = edge.node.name
                            let pieceEdges = edge.node.pieces?.edges ?? []
                            let pieceDetails = pieceEdges.map { $0.node.fragments.pieceDetails }
                            let composer = edge.node.composer
                            return CollectionGroup(id: collectionName, name: collectionName, composer: composer, pieces: pieceDetails)
                        }
                        continuation.resume(returning: groups)
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

    func fetchAllComposers() async throws -> [ComposerType] {
        guard let userId = Database.client.auth.currentUser?.id else {
            return []
        }
        return try await withCheckedThrowingContinuation { continuation in
            let orderBy: GraphQLNullable<[ComposersOrderBy]> = [ComposersOrderBy(lastName: .some(GraphQLEnum(OrderByDirection.ascNullsFirst)))]

            let filter: GraphQLNullable<ComposersFilter> = .some(
                ComposersFilter(
                    or: .some([
                        ComposersFilter(
                            userId: .some(UUIDFilter(eq: .some(userId.uuidString)))
                        ),
                        ComposersFilter(
                            userId: .some(UUIDFilter(is: .some(GraphQLEnum(.null))))
                        ),
                    ])
                )
            )
            Network.shared.apollo.fetch(
                query: ComposersQuery(composerFilter: filter, orderBy: orderBy),
                cachePolicy: .fetchIgnoringCacheData
            ) { result in
                switch result {
                case let .success(graphQLResult):
                    if let edges = graphQLResult.data?.composersCollection?.edges {
                        let nodes = edges.compactMap { ComposerType(firstName: $0.node.firstName, lastName: $0.node.lastName, nationality: $0.node.nationality, id: $0.node.id) }
                        continuation.resume(returning: nodes)
                    } else {
                        continuation.resume(returning: [])
                    }

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func searchComposers() async throws -> [ComposerType]? {
        try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(
                query: SearchComposersQuery(query: searchTerm),
                cachePolicy: .returnCacheDataElseFetch
            ) { result in
                switch result {
                case let .success(graphQLResult):
                    if let edges = graphQLResult.data?.searchComposers?.edges {
                        let nodes = edges.compactMap { ComposerType(firstName: $0.node.firstName, lastName: $0.node.lastName, nationality: $0.node.nationality, id: $0.node.id) }
                        continuation.resume(returning: nodes)
                    } else {
                        continuation.resume(returning: nil)
                    }

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    func count(for filter: SearchFilter) -> Int {
        switch filter {
        case .all:
            return userPieces.count + newPieces.count + collections.count
        case .discover:
            return newPieces.count
        case .userPieces:
            return userPieces.count
        case .composers:
            return composers.count
        case .collections:
            return collections.count
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
