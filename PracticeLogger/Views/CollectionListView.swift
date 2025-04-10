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

    init(collectionId: ApolloGQL.BigInt) {
        self.collectionId = collectionId
        self._isLoading = State(initialValue: true)
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
                        ForEach(edges, id: \.node.id) { item in
                            VStack {
                                Text(item.node.workName)
                                    .font(.headline)
                                if item.node.userId != nil {
                                    if let totalPracticeTime = item.node.totalPracticeTime {
                                        Text(totalPracticeTime.formattedTimeDuration)
                                            .foregroundColor(.secondary)
                                    }
                                } else {
                                    Text("Not added")
                                        .foregroundColor(.secondary)
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
        .navigationTitle(collectionInformation.first?.node.name ?? "Collection")
        .task {
            if isLoading {
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
            print("Error loading collection data: \(error)")
            isLoading = false
        }
    }
}

// #Preview {
//    NavigationView {
//        CollectionListView.previewWithRachmaninoff
//    }
// }
