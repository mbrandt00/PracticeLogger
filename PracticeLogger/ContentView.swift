//
//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI
import MusicKit
struct ContentView: View {
    @State var selectedTab: Tabs = .start
    @State var isTyping: Bool = false
    let bpm: Double = 60
    @State var isSignedIn: Bool = false
    var body: some View {
        VStack {
            if isSignedIn {
                

                if selectedTab == .start {
                    CreatePiece(isTyping: $isTyping)
                }
                if selectedTab == .profile {
                    Profile(isSignedIn: $isSignedIn)
                }

                Spacer()
                CustomTabBar(selectedTab: $selectedTab, isTyping: $isTyping).navigationBarHidden(true)
            } else {
                SignIn(isSignedIn: $isSignedIn)
            }
        }
    }
}

#Preview {
    NavigationView {
        ContentView() // .navigationBarHidden(true)

    }
}
