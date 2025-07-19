import ApolloGQL
import SwiftUI

struct CreateCollection: View {
    @StateObject var viewModel: CollectionsViewModel
    @State private var isLoading = false
    @State private var selectedIDs = Set<String>()

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            TextField("Collection name", text: $viewModel.collectionName)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            TextField("Search your pieces...", text: $viewModel.searchTerm)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)
                .onChange(of: viewModel.searchTerm, initial: false) {
                    Task { await performSearch() }
                }

            Group {
                if isLoading {
                    ProgressView("Searching...")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                } else {
                    pieceList
                }
            }
            .frame(maxHeight: 300)

            Spacer()

            saveButton
        }
        .padding()
        .navigationTitle("New Collection")
        .onAppear {
            Task { await performSearch() }
        }
    }

    // MARK: - Views

    private var pieceList: some View {
        let pieces = filteredAndSelectedPieces()

        return Group {
            if pieces.isEmpty {
                Text("No results")
                    .foregroundStyle(.secondary)
                    .padding(.top, 8)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(pieces, id: \.id) { piece in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
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
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .contentShape(Rectangle())
                            .onTapGesture {
                                toggleSelection(for: piece.id)
                            }
                        }
                    }
                    .padding(.top, 8)
                }
            }
        }
    }

    private var saveButton: some View {
        Button(action: saveSelectedPieces) {
            Text("Save Selected")
                .frame(maxWidth: .infinity)
        }
        .padding()
        .background(selectedIDs.isEmpty ? Color.gray.opacity(0.3) : Color.accentColor)
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .disabled(selectedIDs.isEmpty)
    }

    // MARK: - Logic

    private func performSearch() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await viewModel.searchUserPieces()
        } catch {
            print("Search failed: \(error)")
        }
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

    // ✅ Show search matches + persist selected
    private func filteredAndSelectedPieces() -> [PieceDetails] {
        guard let all = viewModel.selectedPieces else { return [] }

        let searchMatches = all.filter {
            viewModel.searchTerm.isEmpty ||
                $0.workName.localizedCaseInsensitiveContains(viewModel.searchTerm)
        }

        let selected = all.filter { selectedIDs.contains($0.id) }

        // Merge and deduplicate
        return Array(Set(searchMatches + selected))
            .sorted(by: { $0.workName < $1.workName })
    }
}

#Preview {
    NavigationStack {
        CreateCollection(viewModel: CollectionsViewModel())
    }
}
