//
//  RepetoireRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/28/24.
//

import SwiftUI

struct RepertoireRow: View {
    var data: PracticeSession
    var body: some View {
        NavigationLink(value: data) {
            if let workName = data.piece?.workName {
                Text(workName)
            }
            if let composerName = data.piece?.composer?.name {
                Text(composerName)
                    .font(.caption)
            }
        }
        .navigationDestination(for: PracticeSession.self) { ps in
            PieceShow(piece: ps.piece!)
        }
        .padding()
    }
}

#Preview {
    RepertoireRow(data: PracticeSession.example)
}
