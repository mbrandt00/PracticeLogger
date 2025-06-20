//
//  NewItemBadge.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/19/25.
//

import SwiftUI

struct NewItemBadge: View {
    var body: some View {
        HStack(spacing: 2) {
            Image(systemName: "sparkles").font(.caption)
            Text("New").font(.caption)
        }
        .padding(.horizontal, 4)
        .padding(.vertical, 4)
        .background(Color.blue.opacity(0.2))
        .cornerRadius(8)
    }
}
