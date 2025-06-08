//
//  RecentlyDeleted.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/25.
//

import ApolloGQL
import SwiftUI

struct RecentlyDeleted: View {
    @Binding var deletedSessions: [PracticeSessionDetails]

    var body: some View {
        if deletedSessions.isEmpty {
            Text("No deleted sessions.")
        } else {
            List(deletedSessions, id: \.id) { session in
                Text(session.piece.workName)
            }
        }
    }
}

// #Preview {
//    RecentlyDeleted()
// }
