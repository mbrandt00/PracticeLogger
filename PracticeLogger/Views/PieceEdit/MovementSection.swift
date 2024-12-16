//
//  MovementSection.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 12/15/24.
//


import SwiftUI
import ApolloGQL

struct MovementSection: View {
    @Binding var movements: [EditableMovement]
    @Binding var isAddingMovement: Bool
    @Binding var isEditingMovements: Bool
    @Binding var editingMovementId: String?
    @Binding var newMovementName: String
    
    var body: some View {
        Section {
            if movements.isEmpty {
                if isAddingMovement {
                    NewMovementRow(
                        newMovementName: $newMovementName,
                        isAddingMovement: $isAddingMovement,
                        onAdd: addNewMovement
                    )
                } else {
                    Button(action: { isAddingMovement = true }) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("Add First Movement")
                        }
                    }
                }
            } else {
                if isEditingMovements {
                    ForEach(movements, id: \.id) { movement in
                        MovementRow(
                            movement: movement,
                            index: movements.firstIndex(where: { $0.id == movement.id }) ?? 0,
                            isEditing: editingMovementId == movement.id,
                            onEdit: { editingMovementId = movement.id },
                            onDelete: {
                                withAnimation {
                                    if let index = movements.firstIndex(where: { $0.id == movement.id }) {
                                        deleteMovement(at: index)
                                    }
                                }
                            },
                            onUpdate: { newName in
                                withAnimation {
                                    if let index = movements.firstIndex(where: { $0.id == movement.id }) {
                                        updateMovement(at: index, newName: newName)
                                        editingMovementId = nil
                                    }
                                }
                            },
                            onCancelEdit: {
                                withAnimation {
                                    editingMovementId = nil
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
                            isAddingMovement: $isAddingMovement,
                            onAdd: addNewMovement
                        )
                    } else {
                        Button(action: {
                            withAnimation {
                                isAddingMovement = true
                            }
                        }) {
                            HStack {
                                Image(systemName: "plus.circle.fill")
                                Text("Add Movement")
                            }
                        }
                    }
                } else {
                    ForEach(movements, id: \.id) { movement in
                        Text("\(movement.number ?? 0). \(movement.name ?? "")")
                    }
                }
            }
        } header: {
            HStack {
                Text("Movements")
                Spacer()
                Button(action: {
                    withAnimation {
                        isEditingMovements.toggle()
                        if !isEditingMovements {
                            editingMovementId = nil
                            isAddingMovement = false
                            newMovementName = ""
                        }
                    }
                }) {
                    Text(isEditingMovements ? "Done" : "Edit")
                        .foregroundColor(.accentColor)
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
                number: movements.count + 1
            ))
            
            movements.append(newMovement)
            
            newMovementName = ""
        }
    }


    private func updateMovement(at index: Int, newName: String) {
        guard index < movements.count else { return }
        movements[index].name = newName
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
    let isEditing: Bool
    let onEdit: () -> Void
    let onDelete: () -> Void
    let onUpdate: (String) -> Void
    let onCancelEdit: () -> Void
    
    @State private var editedName: String = ""
    
    var body: some View {
        Group {
            if isEditing {
                HStack {
                    TextField("Movement name", text: $editedName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onAppear {
                            editedName = movement.name ?? ""
                        }
                    
                    Button(action: {
                        onUpdate(editedName)
                    }) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                    }
                    
                    Button(action: onCancelEdit) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
                }
            } else {
                HStack {
                    Text("\(index + 1). \(movement.name ?? "")")
                    Spacer()
                    
                    HStack {
                        Button(action: onEdit) {
                            Image(systemName: "pencil.circle")
                                .foregroundColor(.accentColor)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Button(action: onDelete) {
                            Image(systemName: "trash.circle")
                                .foregroundColor(.red)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                }
            }
        }
        .id(movement.id)
    }
}

struct NewMovementRow: View {
    @Binding var newMovementName: String
    @Binding var isAddingMovement: Bool
    let onAdd: () -> Void
    
    var body: some View {
        HStack {
            Image(systemName: "plus.circle.fill")
                .foregroundColor(.accentColor)
            TextField("Movement name", text: $newMovementName)
                .submitLabel(.done)
                .onSubmit(onAdd)
            
            if !newMovementName.isEmpty {
                Button(action: onAdd) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                }
            }
            
            Button(action: {
                withAnimation {
                    isAddingMovement = false
                    newMovementName = ""
                }
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 4)
    }
}

struct PreviewContainer: View {
    @State private var movements = [
        EditableMovement(from: .init(
            id: "1",
            name: "Allegro con brio",
            number: 1
        )),
        EditableMovement(from: .init(
            id: "2",
            name: "Andante con moto",
            number: 2
        )),
        EditableMovement(from: .init(
            id: "3",
            name: "Scherzo: Allegro",
            number: 3
        )),
        EditableMovement(from: .init(
            id: "4",
            name: "Allegro - Presto",
            number: 4
        ))
    ]
    @State private var isAddingMovement = false
    @State private var isEditingMovements = false
    @State private var editingMovementId: String? = nil
    @State private var newMovementName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Preview Controls") {
                    Toggle("Editing Mode", isOn: $isEditingMovements)
                    Toggle("Adding Movement", isOn: $isAddingMovement)
                    Button("Clear All Movements") {
                        movements.removeAll()
                    }
                    Button("Reset to Default Movements") {
                        movements = [
                            EditableMovement(from: .init(
                                id: "1",
                                name: "Allegro con brio",
                                number: 1
                            )),
                            EditableMovement(from: .init(
                                id: "2",
                                name: "Andante con moto",
                                number: 2
                            )),
                            EditableMovement(from: .init(
                                id: "3",
                                name: "Scherzo: Allegro",
                                number: 3
                            )),
                            EditableMovement(from: .init(
                                id: "4",
                                name: "Allegro - Presto",
                                number: 4
                            ))
                        ]
                    }
                }
                
                MovementSection(
                    movements: $movements,
                    isAddingMovement: $isAddingMovement,
                    isEditingMovements: $isEditingMovements,
                    editingMovementId: $editingMovementId,
                    newMovementName: $newMovementName
                )
            }
            .navigationTitle("Movements Preview")
        }
    }
}

struct MovementViews_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            Form {
                
                
                MovementSection(
                    movements: .constant([
                        EditableMovement(from: .init(
                            id: "1",
                            name: "Allegro con brio",
                            number: 1
                        )),
                        EditableMovement(from: .init(
                            id: "2",
                            name: "Andante con moto",
                            number: 2
                        )),
                        EditableMovement(from: .init(
                            id: "3",
                            name: "Scherzo: Allegro",
                            number: 3
                        )),
                        EditableMovement(from: .init(
                            id: "4",
                            name: "Allegro - Presto",
                            number: 4
                        ))
                    ]),
                    isAddingMovement: .constant(false),
                    isEditingMovements: .constant(true),
                    editingMovementId: .constant(nil),
                    newMovementName: .constant("")
                )
            }
            .navigationTitle("Movements Preview")
        }
    }
}
