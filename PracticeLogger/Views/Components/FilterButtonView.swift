//
//  FilterButtonView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/30/25.
//

import SwiftUI

struct FilterButtonView: View {
    @Environment(\.colorScheme) var colorScheme

    var buttonTextColor: Color {
        colorScheme == .dark ? .black : .white
    }

    var text: String
    var categoryCount: Int?
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Text(text)

                if let count = categoryCount {
                    Text("\(count)")
                        .font(.caption2)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .background(isSelected ? Color.primary : .gray.opacity(0.2))
            .foregroundColor(isSelected ? buttonTextColor : .primary)
            .cornerRadius(30)
        }
        .buttonStyle(.plain)
    }
}

struct FilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilterButtonView(text: "All", categoryCount: 5, isSelected: true, action: {})
    }
}
