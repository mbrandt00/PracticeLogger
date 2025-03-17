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
    @State private var editingMode = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                // Piece Header Section
                VStack(alignment: .leading, spacing: 8) {
                    if let composer = piece.composer?.name {
                        Text(composer)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let catalogueDesc = piece.catalogueType, let catalogueNumber = piece.catalogueNumber {
                        Text("\(catalogueDesc.rawValue) \(catalogueNumber)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let nickname = piece.nickname {
                        Text(nickname)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    if let totalTime = piece.totalPracticeTime {
                        HStack {
                            Image(systemName: "clock")
                            Text("Total practice: \(formatDuration(seconds: totalTime))")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                
                // Practice Button
                Button(action: {
                    Task {
                        if sessionManager.activeSession?.piece.id == piece.id && sessionManager.activeSession?.movement?.id == nil {
                            await sessionManager.stopSession()
                        } else {
                            _ = try? await sessionManager.startSession(pieceId: Int(piece.id) ?? 0, movementId: nil)
                        }
                    }
                }, label: {
                    HStack {
                        Image(systemName: sessionManager.activeSession?.movement?.id == nil && sessionManager.activeSession?.piece.id == piece.id ?
                            "stop.circle.fill" : "play.circle.fill")
                        Text(sessionManager.activeSession?.movement?.id == nil && sessionManager.activeSession?.piece.id == piece.id ?
                            "Stop Practice" : "Start Practice")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.accentColor)
                    .cornerRadius(12)
                })
                .padding(.horizontal)
                
                // Movements Section
                if let movementsEdges = piece.movements?.edges, !movementsEdges.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Movements")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(movementsEdges, id: \.node.id) { movement in
                            MovementRow(movement: movement)
                            
                            if movement.node.id != movementsEdges.last?.node.id {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                
                // External Links
                if piece.wikipediaUrl != nil || piece.imslpUrl != nil {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("References")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if let wikipediaUrl = piece.wikipediaUrl {
                            Link(destination: URL(string: wikipediaUrl)!) {
                                HStack {
                                    Image(systemName: "book.fill")
                                    Text("Wikipedia")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        if let imslpUrl = piece.imslpUrl {
                            Link(destination: URL(string: imslpUrl)!) {
                                HStack {
                                    Image(systemName: "doc.fill")
                                    Text("IMSLP")
                                    Spacer()
                                    Image(systemName: "arrow.up.right")
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
        }
        .navigationTitle(piece.workName)
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            Button {
                editingMode = true
            } label: {
                Image(systemName: "pencil")
            }
        }
        .sheet(isPresented: $editingMode) {
            editingMode = false
        } content: {
            NavigationStack {
                PieceEdit(piece: piece, isCreatingNewPiece: false, onPieceCreated: { _ in
                    print("Successfully inserted \(piece)")
                })
                .navigationTitle("Edit \(piece.workName)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    Button("Cancel") {
                        editingMode = false
                    }
                }
            }
        }
    }
    
    private func MovementRow(movement: PieceDetails.Movements.Edge) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                if let movementName = movement.node.name {
                    Text(movementName)
                        .font(.body)
                }
                
                if let number = movement.node.number {
                    Text("Movement \(number)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if let keySignature = movement.node.keySignature, let value = keySignature.value {
                    Text("Key Signature: \(value.displayName)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                if let totalTime = movement.node.totalPracticeTime {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(formatDuration(seconds: totalTime))
                    }
                }
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
                    .font(.title3)
                    .foregroundColor(.accentColor)
            })
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }

    private func formatDuration(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
            
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        } else {
            return "\(minutes)m"
        }
    }
}

#Preview {
    NavigationView {
        PieceShow(
            piece: PieceDetails.allPreviews[0],
            sessionManager: PracticeSessionViewModel()
        )
    }
}
