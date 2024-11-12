//
//  PieceShow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import ApolloGQL
import SwiftUI

struct PieceShow: View {
    var piece: PieceDetails

    @ObservedObject var sessionManager: PracticeSessionViewModel

    var body: some View {
        HStack {
            Text(piece.workName)
                .font(.title)
                .fontWeight(.bold)

            Spacer()

            Button(action: {
                Task {
                    if sessionManager.activeSession?.piece.id == piece.id && sessionManager.activeSession?.movement?.id == nil {
                        await sessionManager.stopSession()
                    } else {
                        _ = try? await sessionManager.startSession(pieceId: Int(piece.id) ?? 0, movementId: nil)
                    }
                }
            }, label: {
                Image(systemName: sessionManager.activeSession?.movement?.id == nil && sessionManager.activeSession?.piece.id == piece.id ?
                    "stop.circle.fill" : "play.circle.fill")
                    .font(.title)
                    .foregroundColor(Color.accentColor)
            })
        }
        .padding(.horizontal)

        ScrollView(showsIndicators: false) {
            if let movementsEdges = piece.movements?.edges {
                ForEach(movementsEdges, id: \.node.id) { movement in
                    MovementRow(movement: movement)
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func MovementRow(movement: PieceDetails.Movements.Edge) -> some View {
        HStack {
            if let movementName = movement.node.name {
                Text(movementName)
                    .font(.body)
            }

            Spacer()

            Button(action: {
                Task {
                    if let movementId = sessionManager.activeSession?.movement?.id {
                        if movementId == movement.node.id {
                            await sessionManager.stopSession()
                        }
                    } else {
                        _ = try? await sessionManager.startSession(pieceId: Int(piece.id) ?? 0, movementId: Int(movement.node.id) ?? 0)
                    }
                }
            }, label: {
                let isActiveMovement = sessionManager.activeSession?.movement?.id == movement.node.id
                Image(systemName: isActiveMovement ? "stop.circle.fill" : "play.circle.fill")
                    .foregroundColor(Color.accentColor)
            })
        }
        .padding(.vertical, 10)
    }
}

// #Preview {
//    PieceShow(piece: Piece.examplePieces.randomElement()!).environmentObject(PracticeSessionViewModel())
// }
