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
    init(preview: [CollectionsQuery.Data.CollectionsCollection.Edge]) {
        self.collectionId = BigInt(0) // Dummy ID for preview
        self._isLoading = State(initialValue: false)
        self._collectionInformation = State(initialValue: preview)
    }

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
            } else {
                List {
                    ForEach(collectionInformation[0].node.pieces?.edges ?? [], id: \.self) { item in
                        HStack {
                            Text(item.node.workName)
                            Spacer()
                            if item.node.userId != nil {
                                Text("Added")
                                    .foregroundColor(.green)
                            } else {
                                Text("Not added")
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle("Collection")
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

#Preview {
    NavigationView {
        CollectionListView.previewWithRachmaninoff
    }
}
