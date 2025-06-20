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
    let composers: [EditableComposer]
    var onComposerSelected: (EditableComposer) -> Void
    var onComposerCreated: (EditableComposer) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var showingCreateSheet = false

    var body: some View {
        List {
            Section(header: Text("Choose a Composer")) {
                Button("None") {
                    selectedComposerId = nil
                    dismiss()
                }

                ForEach(composers, id: \.id) { composer in
                    Button(action: {
                        selectedComposerId = composer.id
                        onComposerSelected(composer)
                        dismiss()
                    }, label: {
                        HStack {
                            Text("\(composer.lastName), \(composer.firstName)")
                            Spacer()
                            if composer.id == selectedComposerId {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.accentColor)
                            }
                        }

                    })
                }
            }

            Section {
                Button("Create New Composer") {
                    showingCreateSheet = true
                }
            }
        }
        .navigationTitle("Select Composer")
        .sheet(isPresented: $showingCreateSheet) {
            CreateComposerView { newComposer in
                Task {
                    do {
                        let response: ComposerInsertResponse = try await Database.client
                            .from("composers")
                            .insert(newComposer)
                            .select()
                            .single()
                            .execute()
                            .value
                        let newEditableComposer = EditableComposer(firstName: response.first_name, lastName: response.last_name, id: String(response.id), nationality: response.nationality)
                        onComposerCreated(newEditableComposer)
                        selectedComposerId = newEditableComposer.id

                        dismiss()
                    } catch {
                        print(error)
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

struct CreateComposerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var nationality: String?
    @State private var musicalEra: String?

    private let musicalEras = [
        "Medieval",
        "Renaissance",
        "Baroque",
        "Classical",
        "Romantic",
        "Impressionist",
        "Modern",
        "Contemporary"
    ]
    var onSave: (EditableComposer) -> Void

    // Computed property to get sorted country names
    private var countryNames: [String] {
        let regions = Locale.Region.isoRegions
        let locale = Locale.current
        return regions
            .compactMap { locale.localizedString(forRegionCode: $0.identifier) }
            .sorted()
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
            .navigationTitle("New Composer")
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Save") {
                    let newComposer = EditableComposer(
                        firstName: firstName,
                        lastName: lastName,
                        userId: Database.client.auth.currentUser!.id.uuidString,
                        nationality: nationality,
                        musicalEra: musicalEra
                    )
                    onSave(newComposer)
                    dismiss()
                }
                .disabled(firstName.isEmpty || lastName.isEmpty)
            )
        }
    }
}
