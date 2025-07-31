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
    @EnvironmentObject var toastManager: GlobalToastManager

    var onDelete: (() -> Void)?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                pieceHeaderSection
                practiceButtonSection
                movementsSection
                referencesSection
                deleteSection
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
            editPieceSheet
        }
        .sheet(isPresented: $editingComposer) {
            composerEditSheet
        }
        .sheet(isPresented: $showingCollectionSheet) {
            collectionSheet
        }
    }
}

// MARK: - View Components

private extension PieceShow {
    @ViewBuilder
    var pieceHeaderSection: some View {
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

            collectionsSection

            if let totalTime = piece.totalPracticeTime {
                HStack {
                    Image(systemName: "clock")
                    Text("Total practice: \(Duration.seconds(totalTime).mediumFormatted)")
                }
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal)
    }

    @ViewBuilder
    var collectionsSection: some View {
        if let collections = piece.collections, !collections.edges.isEmpty {
            VStack(alignment: .leading, spacing: 4) {
                ForEach(collections.edges, id: \.node.id) { c in
                    Button {
                        selectedCollection = (id: c.node.id, name: c.node.name)
                        showingCollectionSheet = true
                    } label: {
                        HStack {
                            Text("\(c.node.name) collection")
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
    }

    @ViewBuilder
    var practiceButtonSection: some View {
        Button(action: {
            Task {
                if sessionManager.activeSession?.piece.id == piece.id && sessionManager.activeSession?.movement?.id == nil {
                    do {
                        try await sessionManager.stopSession()
                    } catch {
                        toastManager.show(
                            type: .error(.red),
                            title: "Something went wrong",
                            subTitle: error.localizedDescription
                        )
                    }
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
    }

    @ViewBuilder
    var movementsSection: some View {
        if let movementsEdges = piece.movements?.edges, !movementsEdges.isEmpty {
            VStack(alignment: .leading, spacing: 2) {
                Text(piece.subPieceType?.capitalized ?? "Movements")
                    .font(.headline)
                    .padding(.horizontal)

                ForEach(movementsEdges, id: \.node.id) { movement in
                    MovementRowView(
                        movement: movement,
                        piece: piece,
                        sessionManager: sessionManager,
                        toastManager: toastManager
                    )

                    if movement.node.id != movementsEdges.last?.node.id {
                        Divider()
                            .padding(.horizontal)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }

    @ViewBuilder
    var referencesSection: some View {
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

    @ViewBuilder
    var deleteSection: some View {
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

// MARK: - Sheet Views

private extension PieceShow {
    @ViewBuilder
    var editPieceSheet: some View {
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
    var composerEditSheet: some View {
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

    @ViewBuilder
    var collectionSheet: some View {
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

// MARK: - Actions

private extension PieceShow {
    func deletePiece() {
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

    func refetchPiece() async throws -> PieceDetails? {
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

// MARK: - Preview

#Preview {
    NavigationView {
        PieceShow(
            piece: PieceDetails.allPreviews[2],
            sessionManager: PracticeSessionViewModel()
        )
    }
}
