//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import SwiftUI
import MusicKit

struct ContentView: View {
    @State private var selectedTab: Tabs = .start
    @State private var isTyping: Bool = false
    @Namespace private var animation
    @State var isExpanded: Bool = false
    

    @ObservedObject private var viewModel = ContentViewViewModel()

    var body: some View {
        VStack {
            if viewModel.isSignedIn {
                if let manager = viewModel.practiceSessionManager {
                    if isExpanded && manager.activeSession != nil {
                        ExpandedBottomSheet(animation: animation, activeSession: manager.activeSession!, expandedSheet: $isExpanded)
                            .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                    } else {
                        VStack {
                            switch selectedTab {
                            case .progress:
                                ProgressView()
                            case .start:
                                CreatePiece(isTyping: $isTyping)
                            case .profile:
                                Profile(isSignedIn: $viewModel.isSignedIn).environmentObject(manager)
                            }

                            Spacer()
                            CustomTabBar(selectedTab: $selectedTab, isTyping: $isTyping, expandedSheet: $isExpanded, animation: animation).environmentObject(manager)
                        }
                    }
                }
            } else {
                SignIn(isSignedIn: $viewModel.isSignedIn)
                    .onChange(of: viewModel.isSignedIn) { newValue in
                        if newValue {
                            viewModel.practiceSessionManager = PracticeSessionManager()
                        }
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
