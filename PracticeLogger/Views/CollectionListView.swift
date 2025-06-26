//
//  CollectionListView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/23/25.
//

import Apollo
import ApolloGQL
import Foundation
import SwiftUI

struct CollectionListView: View {
    @State var collectionId: ApolloGQL.BigInt
    @State private var isLoading: Bool
    @State private var collectionInformation: [CollectionsQuery.Data.CollectionsCollection.Edge]
    @State private var collectionName: String
    @State private var hasAppeared = false
    @State private var selectedPieceForEditing: PieceDetails?
    @State private var selectedPieceForShow: PieceDetails?
    var navigatePieceShow: ((PieceDetails) -> Void)?
    var allPieceEdges: [CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge] {
        var result: [CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge] = []

        for edge in collectionInformation {
            if let edges = edge.node.pieces?.edges {
                result.append(contentsOf: edges)
            }
        }

        return result.sorted {
            let lhsPrimary = $0.node.catalogueNumber
            let rhsPrimary = $1.node.catalogueNumber

            if let lhs = lhsPrimary, let rhs = rhsPrimary, lhs != rhs {
                return lhs < rhs
            } else if lhsPrimary == nil && rhsPrimary != nil {
                return false // nil goes last
            } else if lhsPrimary != nil && rhsPrimary == nil {
                return true
            }

            let lhsSecondary = $0.node.catalogueNumberSecondary
            let rhsSecondary = $1.node.catalogueNumberSecondary

            if let lhs = lhsSecondary, let rhs = rhsSecondary, lhs != rhs {
                return lhs < rhs
            } else if lhsSecondary == nil && rhsSecondary != nil {
                return false
            } else if lhsSecondary != nil && rhsSecondary == nil {
                return true
            }

            return false
        }
    }

    init(collectionId: ApolloGQL.BigInt, collectionName: String, onPieceChanged: ((PieceDetails) -> Void)? = nil) {
        self.collectionId = collectionId
        self.collectionName = collectionName
        _isLoading = State(initialValue: true)
        navigatePieceShow = onPieceChanged
        _collectionInformation = State(initialValue: [])
    }

    // Preview initializer
//    init(preview: [CollectionsQuery.Data.CollectionsCollection.Edge]) {
//        self.collectionId = BigInt(0) // Dummy ID for preview
//        self._isLoading = State(initialValue: false)
//        self._collectionInformation = State(initialValue: preview)
//    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                Text("Loading collection...")
                    .foregroundColor(.secondary)
            } else if collectionInformation.isEmpty {
                Text("No pieces found in this collection")
                    .foregroundColor(.secondary)
            } else if let edges = collectionInformation.first?.node.pieces?.edges {
                if edges.isEmpty {
                    Text("No pieces found in this collection")
                        .foregroundColor(.secondary)
                } else {
                    List {
                        ForEach(allPieceEdges, id: \.node.id) { item in
                            Button(action: {
                                let userId = item.node.userId
                                let tappedPiece = item.node.fragments.pieceDetails
                                if userId == nil {
                                    selectedPieceForEditing = tappedPiece
                                } else {
                                    selectedPieceForShow = tappedPiece
                                    navigatePieceShow?(tappedPiece)
                                }
                            }, label: {
                                pieceRow(for: item)
                            })
                        }
                    }
                }
            } else {
                Text("No pieces found in this collection")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle(collectionName)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(item: $selectedPieceForEditing) { piece in
            PieceEdit(
                piece: piece,
                isCreatingNewPiece: true,
                onPieceCreated: { newPiece in
                    Task {
                        await loadCollectionData()
                    }
                    navigatePieceShow?(newPiece)
                }
            )
        }

        .onAppear {
            guard !hasAppeared else { return }
            hasAppeared = true
            Task {
                await loadCollectionData()
            }
        }
    }

    @ViewBuilder
    private func pieceRow(for item: CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.node.workName)
                    .font(.headline)
                    .foregroundColor(.primary)

                let catalogueType = item.node.catalogueType
                let catalogueNumber = item.node.catalogueNumber

                if let catalogueType, let catalogueNumber {
                    Text("\(catalogueType.displayName) \(catalogueNumber)")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }

            Spacer()

            if item.node.userId == nil {
                Image(systemName: "plus.rectangle")
                    .foregroundColor(.gray)
            } else if let totalPracticeTime = item.node.totalPracticeTime, totalPracticeTime > 0 {
                let duration = Duration.seconds(totalPracticeTime)
                Text("\(duration.shortFormatted) practiced")
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
        .buttonStyle(PlainButtonStyle())
    }

    private func loadCollectionData() async {
        do {
            collectionInformation = try await withCheckedThrowingContinuation { continuation in
                let filter = GraphQLNullable(CollectionsFilter(id: .some(BigIntFilter(eq: .some(collectionId)))))

                Network.shared.apollo.fetch(
                    query: CollectionsQuery(filter: filter),
                    cachePolicy: .fetchIgnoringCacheData
                ) { result in
                    switch result {
                    case let .success(graphQLResult):
                        if let collection = graphQLResult.data?.collectionsCollection?.edges {
                            continuation.resume(returning: collection)
                        } else {
                            continuation.resume(returning: [])
                        }

                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            isLoading = false
        } catch {
            isLoading = false
        }
    }
}

// #Preview {
//    NavigationView {
//        CollectionListView.previewWithRachmaninoff
//    }
// }
