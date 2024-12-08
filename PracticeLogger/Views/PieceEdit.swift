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
    @State private var showToast: Bool = false
    @State private var errorMessage: String = ""
    @State private var duplicatePiece: PieceDetails?
    @Environment(\.presentationMode) var presentationMode
    @Binding var path: NavigationPath
    
    init(piece: PieceDetails, path: Binding<NavigationPath>) {
        _viewModel = StateObject(wrappedValue: PieceEditViewModel(piece: piece))
        _path = path
    }
    
    var body: some View {
        VStack {
            Form {
                Text(viewModel.editablePiece.workName)
                    .font(.title)
                    .foregroundColor(.primary)
                //
                Section(header: Text("Movements").foregroundColor(.primary)) {
                    if let movements = viewModel.editablePiece.movements {
                        ForEach(movements, id: \.id) { movement in
                            Text(movement.name ?? "")
                        }
                    }
                }
                Section(header: Text("Catalogue Information").foregroundColor(.primary)) {
                    
                    Picker("Identifier", selection: Binding<String>(
                        get: {
                            if let catalogueType = viewModel.editablePiece.catalogueType?.rawValue {
                                // Ensure we're using the exact case from the enum
                                if let matchingCase = CatalogueType.allCases.first(where: { $0.rawValue.lowercased() == catalogueType.lowercased() }) {
                                    return matchingCase.rawValue
                                }
                                return ""
                            }
                            return ""
                        },
                        set: { newValue in
                            if let catalogueType = CatalogueType(rawValue: newValue) {
                                viewModel.editablePiece.catalogueType = GraphQLEnum(catalogueType.rawValue)
                            } else {
                                viewModel.editablePiece.catalogueType = nil
                            }
                        }
                    )) {
                        Text("None").tag("")
                        ForEach(CatalogueType.allCases, id: \.self) { catalogueType in
                            Text(catalogueType.rawValue).tag(catalogueType.rawValue)
                        }
                    }
                    
                    HStack {
                        Text("Number")
                            .foregroundColor(.primary)
                        Spacer()
                        TextField("", text: Binding(
                            get: {
                                if let catalogue_number = viewModel.editablePiece.catalogueNumber {
                                    return String(catalogue_number)
                                } else {
                                    return ""
                                }
                            },
                            set: { newValue in
                                viewModel.editablePiece.catalogueNumber = newValue.isEmpty ? nil : Int(newValue)
                            }
                        ))
                        .frame(width: 200)
                        .multilineTextAlignment(.trailing)
                        .textFieldStyle(PlainTextFieldStyle())
                        .keyboardType(.numberPad)
                    }
                    
                    VStack {
                        HStack {
                            Picker("Key Signature", selection: Binding<String>(
                                get: {
                                    if let keySignature = viewModel.editablePiece.keySignature?.rawValue {
                                        return keySignature
                                    }
                                    return ""
                                },
                                set: { newValue in
                                    if let keySignature = KeySignatureType(rawValue: newValue) {
                                        viewModel.editablePiece.keySignature = GraphQLEnum(keySignature)
                                    } else {
                                        viewModel.editablePiece.keySignature = nil
                                    }
                                }
                            )) {
                                Text("None").tag("")
                                ForEach(KeySignatureType.allCases, id: \.self) { keySignatureType in
                                    Text(keySignatureType.displayName)
                                        .tag(keySignatureType.rawValue)
                                }
                            }
                        }
                    }
            }
            if duplicatePiece != nil {
                Text("Duplicate Piece Found!")
                    .font(.subheadline)
                    .foregroundColor(.red)
            }
            
            
                
                
                //                                Picker("Format", selection: Binding( get: {
                //                                        viewModel.piece.format?.rawValue ?? ""
                //                                    },
                //                                    set: { newValue in
                //                                        viewModel.piece.format = Format(rawValue: newValue)
                //                                    }
                //                                )) {
                //                                    Text("").tag("")
                //                                    ForEach(Format.allCases, id: \.self) { format in
                //                                        Text(format.rawValue).tag(format.rawValue)
                //                                    }
                //                                }
                
                //                                HStack {
                //                                    Text("Nickname")
                //                                        .foregroundColor(.primary)
                //                                    Spacer()
                //                                    TextField("", text: Binding(
                //                                        get: {
                //                                            if let nickname = viewModel.piece.nickname {
                //                                                return nickname
                //                                            } else {
                //                                                return ""
                //                                            }
                //                                        },
                //                                        set: { newValue in
                //                                            viewModel.piece.nickname = newValue.isEmpty ? nil : newValue
                //                                        }
                //                                    ))
                //                                    .frame(width: 200)
                //                                    .multilineTextAlignment(.trailing)
                //                                }
            }
            //                            .onAppear {
            //                                Task {
            //                                    do {
            //                                        self.duplicatePiece = try await viewModel.isDuplicate(piece: viewModel.piece)
            //                                    } catch {
            //                                        print(error)
            //                                    }
            //                                }
            //                            }
            //                        }
            //                        .toast(isPresenting: $showToast) {
            //                            AlertToast(type: .error(.red), title: errorMessage)
            //                        }
        }
                            .navigationBarItems(
                                trailing: Button(action: {
                                    Task {
                                        do {
                                            let piece = try await viewModel.insertPiece()
        
                                            path.removeLast() // remove edit page
                                            path.append(PieceNavigationContext.userPiece(piece))
                                        } catch {
                                            print(error.localizedDescription)
                                            if let supabaseError = error as? SupabaseError {
                                                print(supabaseError)
                                                switch supabaseError {
                                                case .pieceAlreadyExists:
                                                    errorMessage = "You have already added this piece"
                                                }
                                            } else {
                                                errorMessage = "An unexpected error occurred."
                                            }
                                            showToast = true
                                        }
                                    }
                                }, label: {
                                    Text("Create")
                                        .foregroundColor(.primary) // Ensure button text adapts to dark mode
                                })
                            )
                            .buttonStyle(.bordered)
                            .foregroundColor(.primary) // Ensure button text adapts to dark mode
                        }
        
        // struct PieceEdit_Previews: PreviewProvider {
        //    static var previews: some View {
        //        PieceEdit(piece: Piece.examplePieces.randomElement()!)
        //            .environment(\.colorScheme, .dark) // Preview in dark mode
        //    }
        // }
        //    }
}
