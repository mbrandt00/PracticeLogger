//
//  MovementRowView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/30/25.
//

//
//  MovementRowView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import ApolloGQL
import SwiftUI

struct MovementRowView: View {
    let movement: PieceDetails.Movements.Edge
    let piece: PieceDetails
    @ObservedObject var sessionManager: PracticeSessionViewModel
    let toastManager: GlobalToastManager

    private var isActive: Bool {
        sessionManager.activeSession?.movement?.id == movement.node.id
    }

    var body: some View {
        HStack(alignment: .center) {
            movementNumberView
            movementInfoView
            Spacer()
            sessionButton
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .padding(.horizontal, 4)
    }
}

// MARK: - View Components

private extension MovementRowView {
    @ViewBuilder
    var movementNumberView: some View {
        if let number = movement.node.number {
            Text("\(number)")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        } else {
            Color.clear
                .frame(width: 40, height: 40)
        }
    }

    @ViewBuilder
    var movementInfoView: some View {
        VStack(alignment: .leading, spacing: 4) {
            if let movementName = movement.node.name {
                Text(movementName)
                    .font(.body)
            }

            if let keySignature = movement.node.keySignature?.value {
                Text(keySignature.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let totalTime = movement.node.totalPracticeTime, totalTime > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(Duration.seconds(totalTime).mediumFormatted)
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    var sessionButton: some View {
        Button(action: {
            Task {
                if isActive {
                    do {
                        try await sessionManager.stopSession()
                    } catch {
                        toastManager.show(
                            type: .error(.red),
                            title: "Something went wrong",
                            subTitle: error.localizedDescription
                        )
                    }
                } else {
                    _ = try? await sessionManager.startSession(
                        pieceId: Int(piece.id) ?? 0,
                        movementId: Int(movement.node.id) ?? 0
                    )
                }
            }
        }, label: {
            Image(systemName: isActive ? "stop.circle.fill" : "play.circle.fill")
                .font(.title2)
                .foregroundColor(Color.accentColor)
                .frame(width: 60, height: 40)
        })
    }
}
