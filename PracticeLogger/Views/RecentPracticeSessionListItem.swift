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
    let onDelete: (String) -> Void
    private var pieceDetails: PieceDetails {
        session.piece.fragments.pieceDetails
    }

    private var formattedCatalogueInfo: String {
        if let catalogueType = pieceDetails.catalogueType, let catalogueNumber = pieceDetails.catalogueNumber {
            return "\(catalogueType.displayName) \(catalogueNumber)"
        }
        return ""
    }

    private var durationText: String {
        session.durationSeconds?.formattedTimeDuration ?? ""
    }

    private var hasMovement: Bool {
        session.movement != nil && session.movement?.name != nil
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // First line: Composer + catalog
            HStack {
                if let composerName = session.piece.fragments.pieceDetails.composer?.name {
                    Text(composerName)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }

                if !formattedCatalogueInfo.isEmpty {
                    Text("•")
                        .font(.footnote)
                        .foregroundColor(.secondary)

                    Text(formattedCatalogueInfo)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                }
            }

            // Second line: Work name
            Text(session.piece.fragments.pieceDetails.workName)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.primary)
                .lineLimit(1)

            // Third line: Movement + duration or just duration
            HStack {
                if hasMovement, let movementName = session.movement?.name {
                    Text(movementName)
                        .font(.footnote)
                        .foregroundColor(.secondary)
                        .lineLimit(1)

                    Text("•")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Text(session.startTime.formatted(.dateTime.hour().minute()))
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text("•")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Text(durationText)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
        .swipeActions {
            Button(role: .destructive) {
                Task {
                    do {
                        let result = try await Database.client.from("practice_sessions")
                            .delete()
                            .eq("id", value: session.id)
                            .execute()
                        await MainActor.run {
                            onDelete(session.id)
                        }
                        print(result)
                    } catch let err {
                        print(err)
                    }
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
