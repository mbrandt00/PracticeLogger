//
//  MovementSection.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 12/15/24.
//

import ApolloGQL
import SwiftUI

struct MovementSection: View {
    @Binding var movements: [EditableMovement]
    @Binding var isAddingMovement: Bool
    @Binding var isEditingMovements: Bool
    @Binding var editingMovementId: String?
    @Binding var newMovementName: String
    @State private var newMovementKeySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?
    @State private var isCreatingNewPiece: Bool

    init(
        movements: Binding<[EditableMovement]>,
        isAddingMovement: Binding<Bool>,
        isEditingMovements: Binding<Bool>,
        editingMovementId: Binding<String?>,
        newMovementName: Binding<String>,
        isCreatingNewPiece: Bool = false
    ) {
        _movements = movements
        _isAddingMovement = isAddingMovement
        _isEditingMovements = isEditingMovements
        _editingMovementId = editingMovementId
        _newMovementName = newMovementName
        self.isCreatingNewPiece = isCreatingNewPiece
    }

    var body: some View {
        Section(header: sectionHeader) {
            sectionContent
        }
    }

    private var sectionHeader: some View {
        HStack {
            Text("Movements")
            Spacer()
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isEditingMovements.toggle()
                    print(movements)
                    if !isEditingMovements {
                        editingMovementId = nil
                        isAddingMovement = false
                        newMovementName = ""
                    }
                }
            }, label: {
                Text(isEditingMovements ? "Done" : "Edit")
                    .foregroundColor(.accentColor)
            })
        }
    }

    private var sectionContent: some View {
        Group {
            if movements.isEmpty {
                emptyContent
            } else {
                VStack(spacing: 0) {
                    if isEditingMovements {
                        editableContent
                    } else {
                        readOnlyContent
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: isEditingMovements) // Single animation modifier
            }
        }
    }

    private var emptyContent: some View {
        Group {
            if isAddingMovement {
                NewMovementRow(
                    newMovementName: $newMovementName,
                    selectedKeySignature: $newMovementKeySignature,
                    isAddingMovement: $isAddingMovement,
                    onAdd: addNewMovement,
                    onKeySignatureUpdate: updateNewMovementKeySignature
                )
            } else {
                Button(action: { isAddingMovement = true }, label: {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("Add First Movement")
                    }
                })
            }
        }
    }

    private var editableContent: some View {
        List {
            ForEach(movements) { movement in
                MovementRow(
                    movement: movement,
                    index: movements.firstIndex(of: movement) ?? 0,
                    isCreatingNewPiece: isCreatingNewPiece,
                    onUpdate: { newName in
                        withAnimation {
                            if let index = movements.firstIndex(of: movement) {
                                updateMovement(at: index, newName: newName)
                            }
                        }
                    },
                    onKeySignatureUpdate: { newKeySignature in
                        withAnimation {
                            if let index = movements.firstIndex(of: movement) {
                                updateMovementKeySignature(at: index, newKeySignature: newKeySignature)
                            }
                        }
                    },
                    onDelete: {
                        withAnimation {
                            if let index = movements.firstIndex(of: movement) {
                                deleteMovement(at: index)
                            }
                        }
                    }
                )
            }
            .onMove { source, destination in
                movements.move(fromOffsets: source, toOffset: destination)
                movements.indices.forEach { movements[$0].number = $0 + 1 }
            }

            if isAddingMovement {
                NewMovementRow(
                    newMovementName: $newMovementName,
                    selectedKeySignature: $newMovementKeySignature,
                    isAddingMovement: $isAddingMovement,
                    onAdd: addNewMovement,
                    onKeySignatureUpdate: updateNewMovementKeySignature
                )
            } else if isCreatingNewPiece {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Movement")
                }
                .onTapGesture {
                    withAnimation {
                        isAddingMovement = true
                    }
                }
                .contentShape(Rectangle())
            }
        }
    }

    private var readOnlyContent: some View {
        Group {
            VStack(spacing: 5) {
                ForEach($movements) { movement in // Use binding directly
                    HStack {
                        Text("\(movement.wrappedValue.number ?? 0). \(movement.wrappedValue.name ?? "")")
                        Spacer()
                        let keySignatureString = movement.wrappedValue.keySignature?.rawValue
                        let keySignatureType = keySignatureString.flatMap(KeySignatureType.init)

                        if let keySignatureType {
                            Text(keySignatureType.displayName)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)

                    if movement.wrappedValue.number != movements.count { // Use number for divider check
                        Divider()
                    }
                }
            }
        }
    }

    private func addNewMovement() {
        guard !newMovementName.isEmpty else { return }

        withAnimation {
            let newMovement = EditableMovement(from: .init(
                id: UUID().uuidString as ApolloGQL.BigInt,
                name: newMovementName,
                keySignature: newMovementKeySignature,
                pieceId: "999",
                number: movements.count + 1
            ))

            movements.append(newMovement)

            newMovementName = ""
            newMovementKeySignature = nil
            isAddingMovement = false
        }
    }

    private func updateMovement(at index: Int, newName: String) {
        guard index < movements.count else { return }
        movements[index].name = newName
    }

    private func updateMovementKeySignature(at index: Int, newKeySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?) {
        guard index < movements.count else { return }
        movements[index].keySignature = newKeySignature
    }

    private func updateNewMovementKeySignature(_ newKeySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?) {
        newMovementKeySignature = newKeySignature
    }

    private func deleteMovement(at index: Int) {
        movements.remove(at: index)

        // Update remaining movement numbers
        for (index, movement) in movements.enumerated() {
            movement.number = index + 1
        }
    }
}

struct MovementRow: View {
    let movement: EditableMovement
    let index: Int
    let isCreatingNewPiece: Bool
    let onUpdate: (String) -> Void
    let onKeySignatureUpdate: (GraphQLEnum<ApolloGQL.KeySignatureType>?) -> Void
    let onDelete: () -> Void // Add new onDelete handler

    @State private var editedName: String = ""
    @State private var selectedKeySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("\(index + 1).")
                TextField(movement.name ?? "", text: $editedName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .onAppear {
                        editedName = movement.name ?? ""
                        selectedKeySignature = movement.keySignature
                    }
                    .onChange(of: editedName) {
                        onUpdate(editedName)
                    }
                Spacer()

                if isCreatingNewPiece {
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }

            KeySignaturePicker(selectedKeySignature: $selectedKeySignature)
                .pickerStyle(MenuPickerStyle())
                .onChange(of: selectedKeySignature) {
                    onKeySignatureUpdate(selectedKeySignature)
                }
        }
    }
}

struct NewMovementRow: View {
    @Binding var newMovementName: String
    @Binding var selectedKeySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?
    @Binding var isAddingMovement: Bool
    let onAdd: () -> Void
    let onKeySignatureUpdate: (GraphQLEnum<ApolloGQL.KeySignatureType>?) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                TextField("New movement name", text: $newMovementName)
                    .textFieldStyle(PlainTextFieldStyle())
                    .autocorrectionDisabled(true)
                    .submitLabel(.done)
                    .onSubmit(onAdd)

                Spacer()

                if !newMovementName.isEmpty {
                    Button(action: onAdd) {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }

                Button(action: {
                    withAnimation {
                        isAddingMovement = false
                        newMovementName = ""
                    }
                }, label: {
                    Image(systemName: "xmark.circle")
                        .foregroundColor(.red)
                        .buttonStyle(BorderlessButtonStyle())
                })
            }

            KeySignaturePicker(selectedKeySignature: $selectedKeySignature)
                .onChange(of: selectedKeySignature) {
                    onKeySignatureUpdate(selectedKeySignature)
                }
        }
        .padding(.vertical, 4)
    }
}

struct KeySignaturePicker: View {
    @Binding var selectedKeySignature: GraphQLEnum<ApolloGQL.KeySignatureType>?

    var body: some View {
        Picker("Key Signature", selection: $selectedKeySignature) {
            Text("").tag(nil as GraphQLEnum<ApolloGQL.KeySignatureType>?)
            ForEach(KeySignatureType.allCases, id: \.self) { type in
                Text(type.displayName)
                    .tag(GraphQLEnum(type) as GraphQLEnum<ApolloGQL.KeySignatureType>?)
            }
        }
        .pickerStyle(.menu)
        .frame(maxWidth: .infinity, alignment: .leading)
        .opacity(selectedKeySignature == nil ? 0.6 : 1)
    }
}

struct PreviewContainer: View {
    @State private var isAddingMovement = false
    @State private var isEditingMovements = true
    @State private var editingMovementId: String?
    @State private var newMovementName = ""
    @State private var movements = [
        EditableMovement(from: .init(
            id: "1" as ApolloGQL.BigInt,
            name: "Allegro con brio",
            pieceId: "preview-piece",
            number: 1
        )),
        EditableMovement(from: .init(
            id: "2" as ApolloGQL.BigInt,
            name: "Andante con moto",
            pieceId: "preview-piece",
            number: 2
        )),
        EditableMovement(from: .init(
            id: "3" as ApolloGQL.BigInt,
            name: "Scherzo: Allegro",
            pieceId: "preview-piece",
            number: 3
        )),
        EditableMovement(from: .init(
            id: "4" as ApolloGQL.BigInt,
            name: "Allegro - Presto",
            pieceId: "preview-piece",
            number: 4
        )),
    ]

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Preview Controls")) {
                    Toggle("Editing Mode", isOn: $isEditingMovements)
                    Toggle("Adding Movement", isOn: $isAddingMovement)
                    Button("Reset to Default Movements") {
                        movements = [
                            EditableMovement(from: .init(
                                id: "1" as ApolloGQL.BigInt,
                                name: "Allegro con brio",
                                pieceId: "preview-piece",
                                number: 1
                            )),
                            EditableMovement(from: .init(
                                id: "2" as ApolloGQL.BigInt,
                                name: "Andante con moto",
                                pieceId: "preview-piece",
                                number: 2
                            )),
                            EditableMovement(from: .init(
                                id: "3" as ApolloGQL.BigInt,
                                name: "Scherzo: Allegro",
                                pieceId: "preview-piece",
                                number: 3
                            )),
                            EditableMovement(from: .init(
                                id: "4" as ApolloGQL.BigInt,
                                name: "Allegro - Presto",
                                pieceId: "preview-piece",
                                number: 4
                            )),
                        ]
                    }
                }

                MovementSection(
                    movements: $movements,
                    isAddingMovement: $isAddingMovement,
                    isEditingMovements: $isEditingMovements,
                    editingMovementId: $editingMovementId,
                    newMovementName: $newMovementName,
                    isCreatingNewPiece: true
                )
            }
            .navigationTitle("Movements Preview")
        }
    }
}

struct MovementViews_Previews: PreviewProvider {
    static var previews: some View {
        PreviewContainer()
    }
}
