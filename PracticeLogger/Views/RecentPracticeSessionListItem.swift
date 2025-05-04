//
//  RecentPracticeSessionListItem.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/4/25.
//
import ApolloGQL
import SwiftUI

struct RecentPracticeSessionListItem: View {
    let session: RecentUserSessionsQuery.Data.PracticeSessionsCollection.Edge.Node

    var body: some View {
        VStack(alignment: .leading) {
            Text(session.piece.workName)
                .font(.title3)
            if let movement = session.movement, let name = movement.name {
                Text(name)
                    .font(.body)
                    .fontWeight(.medium)
            }

            Text(session.startTime.formatted(.dateTime.hour().minute()))
                .font(.subheadline)
                .fontWeight(.regular)

            Text(session.durationSeconds?.formattedTimeDuration ?? "")
                .font(.subheadline)
                .fontWeight(.regular)
        }
        .padding(.vertical, 2)
        .swipeActions {
            Button(role: .destructive) {
                Task {
                    do {
                        let result = try await Database.client.from("practice_sessions")
                            .delete()
                            .eq("id", value: session.id)
                            .execute()

                        print(result)
                    } catch let err {
                        print(err)
                        // Handle errors here
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
