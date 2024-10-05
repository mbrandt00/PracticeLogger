//
//  PracticeSessionView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 10/5/24.
//

import ApolloGQL
import SwiftUI

struct PracticeSessionView: View {
    var session: RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge
    var body: some View {
        Text(session.node.startTime.formatted())
        Text(session.node.endTime?.formatted() ?? "Not yet completed")
    }
}

// #Preview {
//    PracticeSessionView()
// }
