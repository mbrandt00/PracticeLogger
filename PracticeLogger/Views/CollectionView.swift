//
//  CollectionView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/13/25.
//

import ApolloGQL
import SwiftUI

struct CollectionView: View {
    var collection: SearchViewModel.CollectionGroup
    var body: some View {
        Text(collection.name)
    }
}

#Preview {
    CollectionView(collection: SearchViewModel.CollectionGroup(id: "1", name: "", composer: SearchCollectionsQuery.Data.SearchCollections.Edge.Node.Composer(lastName: "Bach", firstName: "JS"), pieces: []))
}
