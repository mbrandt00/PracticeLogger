//
//  Composer.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/13/25.
//

import ApolloGQL
import SwiftUI

struct ComposerView: View {
    var composer: SearchViewModel.ComposerType // change to something universal....
    var fullName: String {
        "\(composer.firstName) \(composer.lastName)"
    }

    var body: some View {
        Text(fullName)
    }
}

// #Preview {
//    ComposerView(composer: SearchViewModel.ComposerType(firstName: "Ludwig van", lastName: "Beethoven", nationality: "German", id: 1))
// }
