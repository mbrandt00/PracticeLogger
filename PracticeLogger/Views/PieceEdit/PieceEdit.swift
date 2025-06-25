//
//  PieceEdit.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/20/24.
//

import AlertToast
import ApolloGQL
import SwiftUI

struct PieceEdit: View {
    @StateObject private var viewModel: PieceEditViewModel
    @State private var showToast = false
    @State private var isCreatingNewPiece: Bool
    @State private var errorMessage = ""
    @State private var duplicatePiece: PieceDetails?
    @State private var newInstrument = ""
    @State private var allComposers: [EditableComposer] = []
    @State private var newMovementName = ""
    @State private var isAddingMovement = false
    @State private var isEditingMovements = false
    @State private var editingMovementId: ApolloGQL.BigInt?
    var onPieceCreated: (@Sendable (PieceDetails) async -> Void)?

    init(piece: PieceDetails, isCreatingNewPiece: Bool, onPieceCreated: ((PieceDetails) async -> Void)? = nil) {
        _viewModel = StateObject(wrappedValue: PieceEditViewModel(piece: piece))
        self.onPieceCreated = onPieceCreated
        self.isCreatingNewPiece = isCreatingNewPiece
    }

    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            nameFields
            MovementSection(
                movements: $viewModel.editablePiece.movements,
                isAddingMovement: $isAddingMovement,
                isEditingMovements: $isEditingMovements,
                editingMovementId: $editingMovementId,
                newMovementName: $newMovementName,
                isCreatingNewPiece: isCreatingNewPiece
            )
            catalogueSection
            instrumentationSection
            externalInformation

            if duplicatePiece != nil {
                Text("Duplicate Piece Found!")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle(isCreatingNewPiece ? "Create Piece" : "Edit Piece")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: createButton)
        .toast(isPresenting: $showToast) {
            AlertToast(type: .error(.red), title: errorMessage)
        }
        .onAppear {
            Task {
                do {
                    allComposers = try await viewModel.fetchComposers() ?? []

                    if let selectedId = viewModel.editablePiece.composerId,
                       !allComposers.contains(where: { $0.id == selectedId }),
                       let composer = viewModel.editablePiece.composer
                    {
                        allComposers.append(composer)
                    }

                } catch {
                    print("Error fetching composers: \(error)")
                }
            }
        }
    }

    private var nameFields: some View {
        Section("Name") {
            workNameField
            nickNameField
            composerField
        }
    }

    private var workNameField: some View {
        HStack {
            Text("Work Name")
            Spacer()
            TextField("Enter name", text: $viewModel.editablePiece.workName)
                .frame(maxWidth: 200)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(PlainTextFieldStyle())
        }
    }

    private var nickNameField: some View {
        HStack {
            Text("Nickname")
            Spacer()
            TextField("Optional", text: Binding(
                get: { viewModel.editablePiece.nickname ?? "" },
                set: { newValue in
                    viewModel.editablePiece.nickname = newValue.isEmpty ? nil : newValue
                }
            ))
            .frame(maxWidth: 200)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(PlainTextFieldStyle())
            .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var composerField: some View {
        Group {
            if viewModel.editablePiece.id == "customPiece" || viewModel.editablePiece.imslpUrl == nil {
                NavigationLink(destination: ComposerSelectionView(
                    selectedComposerId: $viewModel.editablePiece.composerId,
                    composers: allComposers,
                    onComposerSelected: { composer in
                        viewModel.editablePiece.composer = composer
                        viewModel.editablePiece.composerId = composer.id
                    },
                    onComposerCreated: { newComposer in
                        allComposers.append(newComposer)
                        viewModel.editablePiece.composer = newComposer
                        viewModel.editablePiece.composerId = newComposer.id
                    }
                )) {
                    HStack {
                        Text("Composer")
                        Spacer()
                        Text(selectedComposerName)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                HStack {
                    Text("Composer")
                    Spacer()
                    Text(selectedComposerName)
                        .foregroundColor(.gray)
                }
            }
        }
    }

    private var selectedComposerName: String {
        if let id = viewModel.editablePiece.composerId,
           let composer = allComposers.first(where: { $0.id == id })
        {
            return "\(composer.firstName) \(composer.lastName)"
        }
        return "None"
    }

    private var catalogueSection: some View {
        Section("Meta Attributes") {
            cataloguePicker
            catalogueNumberField
            keySignaturePicker
            pieceFormatPicker
            compositionYearField
        }
    }

    private var externalInformation: some View {
        Section("External Information") {
            HStack {
                Text("Wikipedia URL")
                Spacer()
                TextField("Optional", text: Binding(
                    get: { viewModel.editablePiece.wikipediaUrl ?? "" },
                    set: { newValue in
                        viewModel.editablePiece.wikipediaUrl = newValue.isEmpty ? nil : newValue
                    }
                ))
                .frame(maxWidth: 200)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(PlainTextFieldStyle())
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var instrumentationSection: some View {
        Section("Instrumentation") {
            ForEach(viewModel.editablePiece.instrumentation ?? [], id: \.self) { instrument in
                HStack {
                    Text(instrument ?? "")
                    Spacer()
                    Button(action: {
                        viewModel.editablePiece.instrumentation?.removeAll(where: { $0 == instrument })
                    }, label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    })
                }
            }

            HStack {
                TextField("Add instrument", text: $newInstrument)

                Button(action: {
                    guard !newInstrument.isEmpty else { return }
                    if viewModel.editablePiece.instrumentation == nil {
                        viewModel.editablePiece.instrumentation = [newInstrument]
                    } else {
                        viewModel.editablePiece.instrumentation?.append(newInstrument)
                    }
                    newInstrument = ""
                }, label: {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                        .disabled(newInstrument.isEmpty)
                })
            }
        }
    }

    private var cataloguePicker: some View {
        Picker("Identifier", selection: $viewModel.editablePiece.catalogueType) {
            Text("None").tag(nil as GraphQLEnum<CatalogueType>?)
            ForEach(CatalogueType.allCases, id: \.self) { type in
                let graphQLType = GraphQLEnum<CatalogueType>(type)
                Text(graphQLType.displayName)
                    .tag(graphQLType as GraphQLEnum<CatalogueType>?)
            }
        }
    }

    private var catalogueNumberField: some View {
        HStack {
            Text("Number")
            Spacer()
            TextField("", value: $viewModel.editablePiece.catalogueNumber, format: .number)
                .frame(maxWidth: 200)
                .multilineTextAlignment(.trailing)
                .textFieldStyle(PlainTextFieldStyle())
                .keyboardType(.numberPad)
        }
    }

    private var compositionYearField: some View {
        HStack {
            Text("Composition Year")
            Spacer()
            TextField("Optional", text: Binding(
                get: {
                    if let year = viewModel.editablePiece.compositionYear {
                        return String(year)
                    }
                    return ""
                },
                set: { newValue in
                    if let year = Int(newValue) {
                        viewModel.editablePiece.compositionYear = year
                    } else {
                        viewModel.editablePiece.compositionYear = nil
                    }
                }
            ))
            .frame(maxWidth: 200)
            .multilineTextAlignment(.trailing)
            .textFieldStyle(PlainTextFieldStyle())
            .keyboardType(.numberPad)
        }
    }

    private var keySignaturePicker: some View {
        Picker("Key Signature", selection: $viewModel.editablePiece.keySignature) {
            Text("None").tag(nil as GraphQLEnum<ApolloGQL.KeySignatureType>?)
            ForEach(KeySignatureType.allCases, id: \.self) { type in
                Text(type.displayName)
                    .tag(GraphQLEnum(type) as GraphQLEnum<ApolloGQL.KeySignatureType>?)
            }
        }
    }

    private var pieceFormatPicker: some View {
        Picker("Format", selection: $viewModel.editablePiece.format) {
            Text("None").tag(nil as GraphQLEnum<ApolloGQL.PieceFormat>?)
            ForEach(PieceFormat.allCases, id: \.self) { type in
                Text(type.displayName)
                    .tag(GraphQLEnum(type) as GraphQLEnum<ApolloGQL.PieceFormat>?)
            }
        }
    }

    private var createButton: some View {
        Button(isCreatingNewPiece ? "Submit" : "Save") {
            Task {
                do {
                    let piece = isCreatingNewPiece ? try await viewModel.insertPiece() : try await viewModel.updatePiece()
                    dismiss()
                    await onPieceCreated?(piece)

                } catch {
                    print(error)
                }
            }
        }
    }
}

struct PieceEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PieceEdit(
                piece: PieceDetails.previewBach, isCreatingNewPiece: true
            )
        }
    }
}
