//
//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI
import MusicKit
//import Supabase
struct ContentView: View {
    @State var selectedTab: Tabs = .start
    @State var isTyping: Bool = false
    let bpm: Double = 60
    @State var isSignedIn: Bool = false

//    @MainActor @State private var user: User?

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
        .onAppear {
            Task {
                do {
//                    let user = try await viewModel.getUser()
                    isSignedIn = true
                } catch {
                    isSignedIn = false
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ContentView() // .navigationBarHidden(true)

    }
}
