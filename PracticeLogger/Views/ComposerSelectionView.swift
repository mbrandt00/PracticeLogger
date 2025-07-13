//
//  ComposerSelectionView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/17/25.
//
//
//  ComposerSelectionView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/17/25.
//
import ApolloGQL
import Foundation
import SwiftUI

struct ComposerSelectionView: View {
    @Binding var selectedComposerId: String?
    @State private var composerEditMode: ComposerEditMode?
    let composers: [EditableComposer]
    var onComposerSelected: (EditableComposer) -> Void
    var onComposerCreated: (EditableComposer) -> Void

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        List {
            Section(header: Text("Choose a Composer")) {
                Button("None") {
                    selectedComposerId = nil
                    dismiss()
                }

                ForEach(composers, id: \.id) { composer in
                    let composerButton = Button(action: {
                        selectedComposerId = composer.id
                        onComposerSelected(composer)
                        dismiss()
                    }) {
                        HStack {
                            Text("\(composer.lastName), \(composer.firstName)")
                            Spacer()
                            if composer.id == selectedComposerId {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }
                    }

                    Group {
                        if composer.userId != nil {
                            composerButton.contextMenu {
                                Button("Edit") {
                                    composerEditMode = .edit(composer)
                                }
                            }
                        } else {
                            composerButton
                        }
                    }
                }
            }

            Section {
                Button("Create New Composer") {
                    composerEditMode = .create
                }
            }
        }
        .navigationTitle("Select Composer")
        .sheet(item: $composerEditMode) { mode in
            EditComposerView(mode: mode) { updatedComposer in
                Task {
                    do {
                        switch mode {
                        case .create:
                            updatedComposer.id = nil
                            let response: ComposerInsertResponse = try await Database.client
                                .from("composers")
                                .insert(updatedComposer)
                                .select()
                                .single()
                                .execute()
                                .value

                            let newEditableComposer = EditableComposer(
                                firstName: response.first_name,
                                lastName: response.last_name,
                                id: String(response.id),
                                userId: response.user_id,
                                nationality: response.nationality,
                                musicalEra: response.musical_era
                            )

                            onComposerCreated(newEditableComposer)
                            selectedComposerId = newEditableComposer.id

                        case .edit:
                            guard let idString = updatedComposer.id,
                                  let composerId = Int(idString)
                            else {
                                throw NSError(domain: "ComposerSelectionView", code: 1, userInfo: [
                                    NSLocalizedDescriptionKey: "Invalid composer ID: nil or not convertible to Int",
                                ])
                            }

                            let response: ComposerInsertResponse = try await Database.client
                                .from("composers")
                                .update([
                                    "first_name": updatedComposer.firstName,
                                    "last_name": updatedComposer.lastName,
                                    "nationality": updatedComposer.nationality ?? nil,
                                    "musical_era": updatedComposer.musicalEra ?? nil,
                                ])
                                .eq("id", value: composerId)
                                .select()
                                .single()
                                .execute()
                                .value

                            let newEditableComposer = EditableComposer(
                                firstName: response.first_name,
                                lastName: response.last_name,
                                id: String(response.id),
                                userId: response.user_id,
                                nationality: response.nationality,
                                musicalEra: response.musical_era
                            )

                            onComposerSelected(newEditableComposer)
                            selectedComposerId = newEditableComposer.id
                        }

                    } catch {
                        print("Composer save failed: \(error)")
                    }
                }
            }
        }
    }
}

struct ComposerInsertResponse: Decodable {
    let id: Int
    let first_name: String
    let last_name: String
    let nationality: String?
    let musical_era: String?
    let user_id: String
}

struct EditComposerView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var firstName: String
    @State private var lastName: String
    @State private var nationality: String?
    @State private var musicalEra: String?

    let mode: ComposerEditMode
    var onSave: (EditableComposer) -> Void

    init(mode: ComposerEditMode, onSave: @escaping (EditableComposer) -> Void) {
        self.mode = mode
        switch mode {
        case .create:
            _firstName = State(initialValue: "")
            _lastName = State(initialValue: "")
            _nationality = State(initialValue: nil)
            _musicalEra = State(initialValue: nil)

        case let .edit(composer):
            _firstName = State(initialValue: composer.firstName)
            _lastName = State(initialValue: composer.lastName)
            _nationality = State(initialValue: composer.nationality)
            _musicalEra = State(initialValue: composer.musicalEra)
        }
        self.onSave = onSave
    }

    private let musicalEras = [
        "Medieval", "Renaissance", "Baroque", "Classical",
        "Romantic", "Impressionist", "Modern", "Contemporary",
    ]

    private var countryNames: [String] {
        let regions = Locale.Region.isoRegions
        let locale = Locale.current
        let countries = regions.compactMap { locale.localizedString(forRegionCode: $0.identifier) }.sorted()
        return countries
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)

                Picker("Nationality", selection: $nationality) {
                    Text("None").tag(nil as String?)
                    ForEach(countryNames, id: \.self) { country in
                        Text(country).tag(country as String?)
                    }
                }

                Picker("Musical Era", selection: $musicalEra) {
                    Text("None").tag(nil as String?)
                    ForEach(musicalEras, id: \.self) { era in
                        Text(era).tag(era as String?)
                    }
                }
            }
            .navigationTitle(mode == .create ? "New Composer" : "Edit Composer")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button(mode == .create ? "Save" : "Update") {
                    var existingId: String?
                    var existingUserId: String?

                    if case let .edit(composer) = mode {
                        existingId = composer.id
                        existingUserId = composer.userId
                    }

                    let composer = EditableComposer(
                        firstName: firstName,
                        lastName: lastName,
                        id: existingId,
                        userId: existingUserId ?? Database.client.auth.currentUser!.id.uuidString,
                        nationality: nationality,
                        musicalEra: musicalEra
                    )

                    onSave(composer)
                    dismiss()
                }
                .disabled(firstName.isEmpty || lastName.isEmpty)
            )
        }
    }
}

enum ComposerEditMode: Equatable, Identifiable {
    case create
    case edit(EditableComposer)

    static func == (lhs: ComposerEditMode, rhs: ComposerEditMode) -> Bool {
        switch (lhs, rhs) {
        case (.create, .create):
            return true
        case let (.edit(lhsComposer), .edit(rhsComposer)):
            return lhsComposer.id == rhsComposer.id
        default:
            return false
        }
    }

    var id: String {
        switch self {
        case .create:
            return "create"
        case let .edit(composer):
            return composer.id ?? UUID().uuidString
        }
    }
}

struct ComposerEditSheet: View {
    let mode: ComposerEditMode
    let onComplete: (EditableComposer) -> Void

    var body: some View {
        EditComposerView(mode: mode) { updatedComposer in
            Task {
                await saveComposer(mode: mode, updatedComposer: updatedComposer)
            }
        }
    }

    private func saveComposer(mode: ComposerEditMode, updatedComposer: EditableComposer) async {
        do {
            var newComposer: EditableComposer

            switch mode {
            case .create:
                let composerToInsert = updatedComposer
                composerToInsert.id = nil
                let response: ComposerInsertResponse = try await Database.client
                    .from("composers")
                    .insert(composerToInsert)
                    .select()
                    .single()
                    .execute()
                    .value

                newComposer = EditableComposer(
                    firstName: response.first_name,
                    lastName: response.last_name,
                    id: String(response.id),
                    userId: response.user_id,
                    nationality: response.nationality,
                    musicalEra: response.musical_era
                )

            case .edit:
                guard let id = updatedComposer.id else { return }
                let response: ComposerInsertResponse = try await Database.client
                    .from("composers")
                    .update([
                        "first_name": updatedComposer.firstName,
                        "last_name": updatedComposer.lastName,
                        "nationality": updatedComposer.nationality ?? nil,
                        "musical_era": updatedComposer.musicalEra ?? nil,
                    ])
                    .eq("id", value: Int(id)!)
                    .select()
                    .single()
                    .execute()
                    .value

                newComposer = EditableComposer(
                    firstName: response.first_name,
                    lastName: response.last_name,
                    id: String(response.id),
                    userId: response.user_id,
                    nationality: response.nationality,
                    musicalEra: response.musical_era
                )
            }

            onComplete(newComposer)
        } catch {
            print("Composer save failed: \(error)")
        }
    }
}
