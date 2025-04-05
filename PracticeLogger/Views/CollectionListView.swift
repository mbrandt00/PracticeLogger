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
    @State private var collectionInformation: [CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection.Edge]
    
    init(collectionId: ApolloGQL.BigInt) {
        self.collectionId = collectionId
        self._isLoading = State(initialValue: true)
        self._collectionInformation = State(initialValue: [])
    }
    
    // Preview initializer
    init(preview: CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection) {
        self.collectionId = BigInt(0) // Dummy ID for preview
        self._isLoading = State(initialValue: false)
        self._collectionInformation = State(initialValue: preview.edges)
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
                    ForEach(collectionInformation, id: \.self) { item in
                        HStack {
                            Text(item.node.piece?.workName ?? "")
                            Spacer()
                            if item.node.piece?.userId != nil {
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
                let filter = GraphQLNullable(CollectionPiecesWithFallbackFilter(collectionId: .some(BigIntFilter(eq: .some(collectionId)))))
                
                Network.shared.apollo.fetch(query: CollectionPieceWithFallbackQuery(filter: filter)) { result in
                    switch result {
                    case .success(let graphQLResult):
                        if let pieces = graphQLResult.data?.collectionPiecesWithFallbackCollection?.edges {
                            continuation.resume(returning: pieces)
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
        CollectionListView(
            preview: CollectionPieceWithFallbackQuery.Data.CollectionPiecesWithFallbackCollection.previewRachmaninoff
        )
    }
}
