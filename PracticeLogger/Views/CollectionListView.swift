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

/// List view for one collection that shows all pieces
struct CollectionListView: View {
    @State var collectionId: String
    @State private var isLoading: Bool
    @State private var collectionName: String
    @State private var hasAppeared = false
    @State private var selectedPieceForEditing: PieceDetails?
    @State private var selectedPieceForShow: PieceDetails?
    @State private var collection: CollectionsQuery.Data.CollectionsCollection.Edge.Node?

    var navigatePieceShow: ((PieceDetails) -> Void)?

    init(collectionId: String, collectionName: String, onPieceChanged: ((PieceDetails) -> Void)? = nil) {
        self.collectionId = collectionId
        self.collectionName = collectionName
        _isLoading = State(initialValue: true)
        navigatePieceShow = onPieceChanged
    }

    private var sortedPieces: [CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge] {
        guard let edges = collection?.pieces?.edges else { return [] }

        return edges.sorted { edge1, edge2 in
            let piece1 = edge1.node.fragments.pieceDetails
            let piece2 = edge2.node.fragments.pieceDetails

            // Handle nil catalogue numbers - put them at the end
            switch (piece1.catalogueNumber, piece2.catalogueNumber) {
            case (nil, nil):
                // If both are nil, use catalogueNumberSecondary as tiebreaker
                return (piece1.catalogueNumberSecondary ?? Int.max) < (piece2.catalogueNumberSecondary ?? Int.max)
            case (nil, _):
                return false // piece1 goes after piece2
            case (_, nil):
                return true // piece1 goes before piece2
            case let (num1?, num2?):
                if num1 == num2 {
                    // If catalogue numbers are equal, use catalogueNumberSecondary as tiebreaker
                    return (piece1.catalogueNumberSecondary ?? Int.max) < (piece2.catalogueNumberSecondary ?? Int.max)
                }
                return num1 < num2
            }
        }
    }

    var body: some View {
        VStack {
            if isLoading {
                ProgressView()
                    .scaleEffect(1.5)
                    .padding()
                Text("Loading collection...")
                    .foregroundColor(.secondary)
            } else if collection == nil || collection?.pieces?.edges == nil {
                Text("No pieces found in this collection")
                    .foregroundColor(.secondary)
            } else {
                List {
                    ForEach(sortedPieces, id: \.node.id) { edge in
                        Button(action: {
                            let piece = edge.node.fragments.pieceDetails
                            if piece.userId == nil {
                                selectedPieceForEditing = piece
                            } else {
                                selectedPieceForShow = piece
                                navigatePieceShow?(piece)
                            }
                        }, label: {
                            pieceRow(for: edge.node.fragments.pieceDetails)
                        })
                        .buttonStyle(PlainButtonStyle())
                    }
                }
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
    private func pieceRow(for item: PieceDetails) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(item.workName)
                    .font(.headline)
                    .foregroundColor(.primary)

                let catalogueType = item.catalogueType
                let catalogueNumber = item.catalogueNumber

                if let catalogueType, let catalogueNumber {
                    Text("\(catalogueType.displayName) \(catalogueNumber)")
                        .foregroundColor(.secondary)
                        .font(.subheadline)
                }
            }

            Spacer()

            if item.userId == nil {
                Image(systemName: "plus.rectangle")
                    .foregroundColor(.gray)
            } else if let totalPracticeTime = item.totalPracticeTime, totalPracticeTime > 0 {
                let duration = Duration.seconds(totalPracticeTime)
                Text("\(duration.shortFormatted) practiced")
                    .foregroundColor(.secondary)
                    .font(.footnote)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .contentShape(Rectangle())
    }

    private func loadCollectionData() async {
        do {
            let fetchedEdges: [CollectionsQuery.Data.CollectionsCollection.Edge] = try await withCheckedThrowingContinuation { continuation in
                let filter = GraphQLNullable(CollectionsFilter(id: .some(BigIntFilter(eq: .some(collectionId)))))

                Network.shared.apollo.fetch(
                    query: CollectionsQuery(filter: filter),
                    cachePolicy: .fetchIgnoringCacheData
                ) { result in
                    switch result {
                    case let .success(graphQLResult):
                        if let edges = graphQLResult.data?.collectionsCollection?.edges {
                            continuation.resume(returning: edges)
                        } else {
                            continuation.resume(returning: [])
                        }

                    case let .failure(error):
                        continuation.resume(throwing: error)
                    }
                }
            }

            // Set the collection data
            collection = fetchedEdges.first?.node
            isLoading = false
        } catch {
            isLoading = false
        }
    }
}
