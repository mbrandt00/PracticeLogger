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
                        do {
                            _ = try await sessionManager.startSession(record: .piece(piece))
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                }, label: {
                    Image(systemName: "play.circle.fill")
                        .font(.title)
                        .foregroundColor(Color.accentColor)
                })
            }

            ForEach(piece.movements, id: \.self) { movement in
                HStack {
                    Text(movement.name)
                        .font(.body)

                    Spacer()

                    Button(action: {
                        Task {
                            try await sessionManager.startSession(record: .movement(movement))
                        }
                    }, label: {
                        Image(systemName: "play.circle.fill")
                            .foregroundColor(Color.accentColor)
                    })
                }
                .padding(.vertical, 5)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color(UIColor.systemBackground))
    }
}
#Preview {
    PieceShow(piece: Piece.example)
}
