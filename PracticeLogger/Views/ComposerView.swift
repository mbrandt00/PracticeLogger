//
//  Composer.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/13/25.
//

import ApolloGQL
import SwiftUI

struct ComposerView: View {
    var composer: SearchComposersQuery.Data.SearchComposers.Edge.Node
    var fullName: String {
        "\(composer.firstName) \(composer.lastName)"
    }

    var body: some View {
        Text(fullName)
    }
}

#Preview {
    ComposerView(composer: SearchComposersQuery.Data.SearchComposers.Edge.Node(id: BigInt(1), lastName: "Beethoven", firstName: "Ludwig van", nationality: "German"))
}
