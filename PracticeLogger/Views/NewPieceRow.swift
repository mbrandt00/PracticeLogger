//
//  NewPieceRow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 3/10/24.
//

import SwiftUI

struct NewPieceRow: View {
    let piece: Piece
    @State private var isExpanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(piece.workName)
                    .font(.title3)
                
                Spacer()
                
                DisclosureGroup(isExpanded: $isExpanded) {
                } label: {
                    HStack {
                        Text("\(piece.movements.count) movements")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.horizontal, 10) // Add padding to the label
                            .background(Color.gray.opacity(0.2)) // Apply the same gray padding
                            .cornerRadius(6) // Add corner radius for aesthetics
                            .padding(.leading)
                    }
                }
            }
            
            if isExpanded {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(piece.movements) { movement in
                        Text(movement.name)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.leading, 40) // Indent content to match disclosure label
                    }
                }
                .padding(.top, 10) // Add some space between label and content
            }
        }
        .padding()
    }
}







#Preview {
    NewPieceRow(piece: Piece(workName: "Chopin Sonata 2", composer: Composer(name: "Frederic Chopin"), movements:
                                [
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Fuenbre", number: 3),
                                    Movement(name: "Finale", number: 4),
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Fuenbre", number: 3),
                                    Movement(name: "Finale", number: 4),
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Fuenbre", number: 3),
                                    Movement(name: "Finale", number: 4),
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Fuenbre", number: 3),
                                    Movement(name: "Finale", number: 4),
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Fuenbre", number: 3),
                                    Movement(name: "Finale", number: 4),
                                    Movement(name: "Grave - Doppio movimento", number: 1),
                                    Movement(name: "Scherzo- Piu lento - Tempo 1", number: 2),
                                    Movement(name: "Marche Fuenbre", number: 3),
                                    Movement(name: "Finale", number: 4)
                                ])).previewLayout(.sizeThatFits)
    
}
