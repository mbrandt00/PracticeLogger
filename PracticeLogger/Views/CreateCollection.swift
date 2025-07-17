//
//  CreateCollection.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/15/25.
//

import ApolloGQL
import SwiftUI

struct CreateCollection: View {
    @StateObject var viewModel = CollectionsViewModel()
    @State private var isLoading = false
    @State private var selectedIDs = Set<String>()
    var body: some View {
        VStack(spacing: 0) {
            // 🔍 Fixed Search bar
            TextField("Search your pieces...", text: $viewModel.searchTerm)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .padding()
                .background(Color(.systemBackground)) // Keep background consistent
                .onChange(of: viewModel.searchTerm, initial: false) {
                    Task {
                        await performSearch()
                    }
                }

            // 📃 Scrollable Results
            if isLoading {
                ProgressView()
                    .padding()
                Spacer()
            } else {
                List {
                    if let pieces = viewModel.selectedPieces, !pieces.isEmpty {
                        ForEach(pieces, id: \.id) { piece in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(piece.workName)
                                        .font(.headline)
                                    if let composer = piece.composer {
                                        Text("\(composer.firstName.capitalized) \(composer.lastName)")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Spacer()
                                if selectedIDs.contains(piece.id) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(for: piece.id)
                            }
                        }
                    } else {
                        Text("No results")
                            .foregroundStyle(.secondary)
                    }
                }
                .listStyle(.plain)
            }

            // ✅ Save Button at Bottom
            Button("Save Selected") {
                saveSelectedPieces()
            }
            .padding()
            .disabled(selectedIDs.isEmpty)
        }
        .navigationTitle("New Collection")
        .onAppear {
            Task {
                await performSearch()
            }
        }
    }

    // MARK: - Actions

    private func performSearch() async {
        isLoading = true
        do {
            try await viewModel.searchUserPieces()
        } catch {
            print("Search failed: \(error)")
        }
        isLoading = false
    }

    private func toggleSelection(for id: String) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }

    private func saveSelectedPieces() {
        guard let all = viewModel.selectedPieces else { return }
        viewModel.selectedPieces = all.filter { selectedIDs.contains($0.id) }
    }
}
