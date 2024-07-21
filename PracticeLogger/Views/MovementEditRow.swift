//
//  MovementEditRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 5/12/24.
//

import SwiftUI

struct MovementEditRow: View {
    var movement: Movement
    var onUpdateMovementName: (String) -> Void

    var body: some View {
        HStack {
            Text(movement.number.toRomanNumeral() ?? "")
                .font(.caption)
                .frame(width: 24, height: 14)
                .foregroundColor(.secondary)
            TextField("", text: Binding(
                get: {
                    movement.name
                },
                set: { newValue, _ in
                    onUpdateMovementName(newValue)
                }
            ))
            .font(.subheadline)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    MovementEditRow(
        movement: Movement(name: "Grave - Doppio movimento", number: 1),
        onUpdateMovementName: { _ in }
    )
}
