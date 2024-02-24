//
//  NewPracticeSession.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI

struct NewPracticeSession: View {
    @State private var pieceName = ""
    @State private var composer = ""
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Piece Information")){
                    TextField("Piece Name", text: $pieceName)
                    TextField("Composer", text: $composer)
                }
            }
        }
    }
    
}

#Preview {
    NewPracticeSession()
}
