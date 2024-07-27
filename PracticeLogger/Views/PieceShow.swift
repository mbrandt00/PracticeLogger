//
//  PieceShow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import SwiftUI

struct PieceShow: View {
    var piece: Piece
    @EnvironmentObject var sessionManager: PracticeSessionViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text(piece.workName)
                    .font(.title)
                    .fontWeight(.bold)

                Spacer()

                Button(action: {
                    Task {
                        if sessionManager.activeSession?.pieceId == piece.id && sessionManager.activeSession?.movementId == nil {
                            await sessionManager.stopSession()
                        } else {
                            _ = try await sessionManager.startSession(record: .piece(piece))
                        }
                    }
                }, label: {
                    Image(systemName: sessionManager.activeSession?.movementId == nil && sessionManager.activeSession?.pieceId == piece.id ?
                        "stop.circle.fill" : "play.circle.fill")
                        .font(.title)
                        .foregroundColor(Color.accentColor)
                        .font(.title)
                        .foregroundColor(Color.accentColor)
                })
            }
            ScrollView(showsIndicators: false, content: {
                ForEach(piece.movements, id: \.self) { movement in
                    HStack {
                        Text(movement.name)
                            .font(.body)

                        Spacer()

                        Button(action: {
                            Task {
                                if sessionManager.activeSession?.movementId == movement.id {
                                    await sessionManager.stopSession()
                                } else {
                                    _ = try await sessionManager.startSession(record: .movement(movement))
                                }
                            }
                        }, label: {
                            Image(systemName: sessionManager.activeSession?.movementId == movement.id ? "stop.circle.fill" : "play.circle.fill")
                                .foregroundColor(Color.accentColor)
                        })
                    }
                    .padding(.vertical, 10) // testing
                }
            })
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    PieceShow(piece: Piece.example)
}
