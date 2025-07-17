//
//  PieceShow.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/8/24.
//

import Apollo
import ApolloGQL
import SwiftUI

struct PieceShow: View {
    @State var piece: PieceDetails
    @ObservedObject var sessionManager: PracticeSessionViewModel
    @State private var editingMode = false
    @State private var showingDeleteConfirmation = false
    @State private var editingComposer = false
    @State private var showingCollectionSheet = false
    @State private var selectedCollection: (id: String, name: String)?
    var onDelete: (() -> Void)?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    if let nickname = piece.nickname {
                        Text(nickname)
                            .font(.headline)
                            .foregroundColor(.secondary)
                    }
                    if let composer = piece.composer {
                        Text("\(composer.firstName) \(composer.lastName)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        if composer.userId != nil {
                            Button(action: {
                                self.editingComposer = true
                            }, label: {
                                Text("Edit")
                            })
                        }
                    }

                    if let catalogueDesc = piece.catalogueType, let catalogueNumber = piece.catalogueNumber {
                        HStack(spacing: 4) {
                            Text("\(catalogueDesc.displayName) \(catalogueNumber)")
                            if let compositionYear = piece.compositionYear {
                                Text("(\(String(compositionYear)))")
                            }
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    if let collections = piece.collections, !collections.edges.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            ForEach(collections.edges, id: \.node.id) { c in
                                Button {
                                    selectedCollection = (id: c.node.collection.id, name: c.node.collection.name)
                                    showingCollectionSheet = true
                                } label: {
                                    HStack {
                                        Text("\(c.node.collection.name) collection")
                                            .font(.body)
                                            .foregroundColor(.accentColor)

                                        Image(systemName: "chevron.right")
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 8)
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
                    VStack(alignment: .leading, spacing: 2) {
                        Text(piece.subPieceType?.capitalized ?? "Movements")
                            .font(.headline)
                            .padding(.horizontal)

                        ForEach(movementsEdges, id: \.node.id) { movement in
                            movementRow(for: movement)

                            if movement.node.id != movementsEdges.last?.node.id {
                                Divider()
                                    .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical, 4)
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
                Button(role: .destructive, action: {
                    showingDeleteConfirmation = true
                }, label: {
                    HStack {
                        Spacer()
                        Label("Delete Piece", systemImage: "trash")
                            .font(.body)
                            .padding()
                        Spacer()
                    }
                })
                .padding(.horizontal)
                .background(Color.red.opacity(0.1))
                .cornerRadius(12)
                .padding(.top, 32)
                .padding(.horizontal)
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
        .alert("Delete Piece?", isPresented: $showingDeleteConfirmation, actions: {
            Button("Delete", role: .destructive, action: deletePiece)
            Button("Cancel", role: .cancel) {}
        }, message: {
            Text("This action cannot be undone.")
        })
        .sheet(isPresented: $editingMode) {
            EditPieceSheetView()
        }
        .sheet(isPresented: $editingComposer) {
            ComposerEditSheet(mode: .edit(EditableComposer(from: piece.composer!)), onComplete: { (_: EditableComposer) in
                Task {
                    do {
                        if let updatedPiece = try await refetchPiece() {
                            piece = updatedPiece
                            try await sessionManager.fetchCurrentActiveSession()
                        }
                    } catch {
                        print("Error refetching piece: \(error)")
                    }
                }
            })
        }
        .sheet(isPresented: $showingCollectionSheet) {
            if let selectedCollection {
                NavigationStack {
                    CollectionListView(
                        collectionId: selectedCollection.id,
                        collectionName: selectedCollection.name,
                        onPieceChanged: { newPiece in
                            piece = newPiece
                            showingCollectionSheet = false
                        }
                    )
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                showingCollectionSheet = false
                            }
                        }
                    }
                }
            }
        }
    }

    private func deletePiece() {
        Task {
            do {
                let pieceId = piece.id
                print("Deleting piece \(pieceId)")

                let result = try await Database.client.from("pieces")
                    .delete()
                    .eq("id", value: pieceId)
                    .execute()

                print("RESULT", result)

                Network.shared.apollo.store.withinReadWriteTransaction { transaction in
                    let cacheKey = CacheKey("\(piece.__typename):\(piece.id)")
                    try transaction.removeObject(for: cacheKey)
                }

                await MainActor.run {
                    if piece.id == sessionManager.activeSession?.piece.id {
                        sessionManager.activeSession = nil
                    }

                    onDelete?()
                    dismiss()
                }

            } catch {
                print("Error deleting piece:", error)
            }
        }
    }

    private func EditPieceSheetView() -> some View {
        NavigationStack {
            PieceEdit(piece: piece, isCreatingNewPiece: false, onPieceCreated: { updatedPiece in
                piece = updatedPiece
            })
            .navigationTitle("Edit \(piece.workName)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        editingMode = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func movementRow(for movement: PieceDetails.Movements.Edge) -> some View {
        HStack(alignment: .center) {
            movementNumberView(movement)
            movementInfoView(movement)
            Spacer()
            sessionButton(for: movement)
        }
        .padding(.top, 8)
        .padding(.bottom, 4)
        .padding(.horizontal, 4)
    }

    @ViewBuilder
    private func movementNumberView(_ movement: PieceDetails.Movements.Edge) -> some View {
        if let number = movement.node.number {
            Text("\(number)")
                .font(.headline)
                .foregroundColor(.primary)
                .frame(width: 40, height: 40)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
        } else {
            Color.clear
                .frame(width: 40, height: 40)
        }
    }

    @ViewBuilder
    private func movementInfoView(_ movement: PieceDetails.Movements.Edge) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            if let movementName = movement.node.name {
                Text(movementName)
                    .font(.body)
            }

            if let keySignature = movement.node.keySignature?.value {
                Text(keySignature.displayName)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            if let totalTime = movement.node.totalPracticeTime, totalTime > 0 {
                HStack(spacing: 4) {
                    Image(systemName: "clock")
                    Text(formatDuration(seconds: totalTime))
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
        .frame(maxHeight: .infinity)
    }

    @ViewBuilder
    private func sessionButton(for movement: PieceDetails.Movements.Edge) -> some View {
        let isActive = sessionManager.activeSession?.movement?.id == movement.node.id

        Button(action: {
            Task {
                if isActive {
                    await sessionManager.stopSession()
                } else {
                    _ = try? await sessionManager.startSession(
                        pieceId: Int(piece.id) ?? 0,
                        movementId: Int(movement.node.id) ?? 0
                    )
                }
            }
        }, label: {
            Image(systemName: isActive ? "stop.circle.fill" : "play.circle.fill")
                .font(.title2)
                .foregroundColor(Color.accentColor)
                .frame(width: 60, height: 40)
        })
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

    private func refetchPiece() async throws -> PieceDetails? {
        return try await withCheckedThrowingContinuation { continuation in
            Network.shared.apollo.fetch(query: PiecesQuery(pieceFilter: PieceFilter(id: .some(BigIntFilter(eq: .some(piece.id)))))) { result in
                switch result {
                case let .success(graphQlResult):
                    if let piece = graphQlResult.data?.pieceCollection?.edges.first {
                        continuation.resume(returning: piece.node.fragments.pieceDetails)
                    } else {
                        continuation.resume(returning: nil)
                    }

                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        PieceShow(
            piece: PieceDetails.allPreviews[2],
            sessionManager: PracticeSessionViewModel()
        )
    }
}
