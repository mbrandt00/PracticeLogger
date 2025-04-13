//
//  CollectionListView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/23/25.
//

import ApolloGQL
import SwiftUI

struct CollectionListView: View {
    @State var collectionId: ApolloGQL.BigInt
    @State private var isLoading: Bool
    @State private var collectionInformation: [CollectionsQuery.Data.CollectionsCollection.Edge]
    @State private var collectionName: String
    @State private var hasAppeared = false
    @State private var selectedPieceForEditing: PieceDetails?
    @State private var selectedPieceForShow: PieceDetails?
    var onPieceCreated: ((PieceDetails) -> Void)?
    var allPieceEdges: [CollectionsQuery.Data.CollectionsCollection.Edge.Node.Pieces.Edge] {
        collectionInformation.flatMap { $0.node.pieces?.edges ?? [] }
    }

    init(collectionId: ApolloGQL.BigInt, collectionName: String, onPieceChanged: ((PieceDetails) -> Void)? = nil) {
        self.collectionId = collectionId
        self.collectionName = collectionName
        self._isLoading = State(initialValue: true)
        self.onPieceCreated = onPieceChanged
        self._collectionInformation = State(initialValue: [])
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
                            VStack(alignment: .leading) {
                                Text(item.node.workName)
                                    .font(.headline)

                                if let catalogueType = item.node.catalogueType, let catalogueNumber = item.node.catalogueNumber {
                                    Text("\(catalogueType.displayName) \(catalogueNumber)")
                                }

                                if let userId = item.node.userId {
                                    if let totalPracticeTime = item.node.totalPracticeTime {
                                        Text(totalPracticeTime.formattedTimeDuration)
                                            .foregroundColor(.secondary)
                                    }
                                } else {
                                    HStack {
                                        Image(systemName: "plus.rectangle")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                let tappedPiece = item.node.fragments.pieceDetails

                                if tappedPiece.userId == nil {
                                    selectedPieceForEditing = tappedPiece
                                } else {
                                    selectedPieceForShow = tappedPiece
                                    onPieceCreated?(tappedPiece)
                                }
                            }
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
                onPieceCreated: onPieceCreated
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

    private func loadCollectionData() async {
        do {
            collectionInformation = try await withCheckedThrowingContinuation { continuation in
                let filter = GraphQLNullable(CollectionsFilter(id: .some(BigIntFilter(eq: .some(collectionId)))))

                Network.shared.apollo.fetch(query: CollectionsQuery(filter: filter)) { result in
                    switch result {
                    case .success(let graphQLResult):
                        if let collection = graphQLResult.data?.collectionsCollection?.edges {
                            continuation.resume(returning: collection)
                        } else {
                            continuation.resume(returning: [])
                        }
                    case .failure(let error):
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
