//
//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Practice Logger").font(.title).padding()
                Image(systemName: "music.note")
                    .imageScale(.large)
                    .foregroundStyle(.tint).padding()
                Text("Recent Pieces").font(.headline)
                
                Spacer()
                NavigationLink(destination: NewPracticeSession()) {
                    Text("Add practice session")
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
