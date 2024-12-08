//
//  PieceEdit.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 4/20/24.
//

import AlertToast
import SwiftUI
import ApolloGQL
struct PieceEdit: View {
    @StateObject private var viewModel: PieceEditViewModel
    @State private var showToast = false
    @State private var errorMessage = ""
    @State private var duplicatePiece: PieceDetails?
    @Binding var path: NavigationPath
    @State private var newInstrument = ""
    
    init(piece: PieceDetails, path: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: PieceEditViewModel(piece: piece))
        _path = path
    }
    
    var body: some View {
        Form {
            nameFields
            movementsSection
            catalogueSection
            instrumentationSection
            externalInformation
            
            if duplicatePiece != nil {
                Text("Duplicate Piece Found!")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
        }
        .navigationTitle("Create Piece")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: createButton)
        .toast(isPresenting: $showToast) {
            AlertToast(type: .error(.red), title: errorMessage)
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
    
    public var composerField: some View {
        HStack {
            Text("Composer")
            Spacer()
            TextField("Composer", text: Binding(
                get: { viewModel.editablePiece.composer?.name ?? "" },
                set: { newValue in
                    if viewModel.editablePiece.composer == nil {
                        viewModel.editablePiece.composer = EditableComposer(name: newValue)
                    } else {
                        viewModel.editablePiece.composer?.name = newValue
                    }
                }
            ))
            .multilineTextAlignment(.trailing)
        }
    }
    
    private var movementsSection: some View {
        Section("Movements") {
            if let movements = viewModel.editablePiece.movements {
                ForEach(movements, id: \.id) { movement in
                    Text(movement.name ?? "")
                }
            }
        }
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
            
            HStack {
                Text("IMSLP URL")
                Spacer()
                TextField("Optional", text: Binding(
                    get: { viewModel.editablePiece.imslpUrl ?? "" },
                    set: { newValue in
                        viewModel.editablePiece.imslpUrl = newValue.isEmpty ? nil : newValue
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
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.red)
                    }
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
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.accentColor)
                }
                .disabled(newInstrument.isEmpty)
            }
        }
    }
    
    private var cataloguePicker: some View {
        Picker("Identifier", selection: $viewModel.editablePiece.catalogueType) {
            Text("None").tag(nil as GraphQLEnum<ApolloGQL.CatalogueType>?)
            ForEach(CatalogueType.allCases, id: \.self) { type in
                Text(type.rawValue)
                    .tag(GraphQLEnum(type.rawValue) as GraphQLEnum<ApolloGQL.CatalogueType>?)
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
        Button("Submit") {
            Task {
                do {
                    
                    let piece = try await viewModel.insertPiece()
//                    path.removeLast()
//                    path.append(PieceNavigationContext.userPiece(piece))
                } catch let error as SupabaseError {
                    errorMessage = error == .pieceAlreadyExists
                        ? "You have already added this piece"
                        : "An unexpected error occurred."
                    showToast = true
                } catch {
                    errorMessage = "An unexpected error occurred."
                    showToast = true
                }
            }
        }
        .buttonStyle(.bordered)
        .foregroundColor(.primary)
    }
}

struct PieceEdit_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            PieceEdit(
                piece: PieceDetails(
                    id: "12345",
                    workName: "Symphony No. 5",
                    catalogueType: GraphQLEnum(CatalogueType.Op.rawValue),
                    keySignature: GraphQLEnum(KeySignatureType.cminor),
                    format: GraphQLEnum(PieceFormat.symphony.rawValue),
                    instrumentation: ["Violin", "Cello", "Bassoon", "Chorus"],
                    wikipediaUrl: "https://en.wikipedia.org/wiki/Symphony_No._5_(Beethoven)",
                    imslpUrl: "https://imslp.org/wiki/Symphony_No.5,_Op.67_(Beethoven,_Ludwig_van)",
                    compositionYear: 1804,
                    catalogueNumber: 67,
                    nickname: "My really really really long nickname jkl;asd",
                    composer: PieceDetails.Composer(name: "Ludwig van Beethoven"),
                    movements: PieceDetails.Movements(
                        edges: [
                            PieceDetails.Movements.Edge(
                                node: PieceDetails.Movements.Edge.Node(
                                    id: "1",
                                    name: "Allegro con brio",
                                    number: 1
                                )
                            ),
                            PieceDetails.Movements.Edge(
                                node: PieceDetails.Movements.Edge.Node(
                                    id: "2",
                                    name: "Andante con moto",
                                    number: 2
                                )
                            ),
                            PieceDetails.Movements.Edge(
                                node: PieceDetails.Movements.Edge.Node(
                                    id: "3",
                                    name: "Scherzo: Allegro",
                                    number: 3
                                )
                            ),
                            PieceDetails.Movements.Edge(
                                node: PieceDetails.Movements.Edge.Node(
                                    id: "4",
                                    name: "Allegro - Presto",
                                    number: 4
                                )
                            )
                        ]
                    )
                ),
                path: .constant(NavigationPath())
            )
        }
    }
}
