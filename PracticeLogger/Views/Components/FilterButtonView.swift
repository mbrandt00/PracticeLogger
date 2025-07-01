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
        if colorScheme == .dark {
            return .black
        } else {
            return .white
        }
    }

    var text: String
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button {
            action()
        } label: {
            Text(text)
                .padding(.horizontal)
                .padding(.vertical, 6)
                .background(isSelected ? Color.primary : .gray.opacity(0.2))
                .foregroundColor(isSelected ? buttonTextColor : .primary)
                .cornerRadius(30)
                .overlay(RoundedRectangle(cornerRadius: 30).strokeBorder(.primary, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

struct FilterButtonView_Previews: PreviewProvider {
    static var previews: some View {
        FilterButtonView(text: "All", isSelected: true, action: {})
    }
}
