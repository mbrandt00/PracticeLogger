//
//  Tag.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/27/24.
//

import SwiftUI

struct Tag: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(.secondary)
            .padding(.horizontal, 5)
            .background(Color.gray.opacity(0.2))
            .cornerRadius(6)
    }
}

#Preview {
    Tag("Text")
}
