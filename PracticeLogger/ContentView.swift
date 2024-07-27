//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import MusicKit
import SwiftUI

struct ContentView: View {
    @Binding var isSignedIn: Bool
    @State private var selectedTab: Tabs = .start
    @Namespace private var animation
    @State private var isExpanded: Bool = false
    @StateObject var viewModel = PracticeSessionViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
        if isSignedIn {
            if isExpanded {
                if let activeSession = viewModel.activeSession {
                    ExpandedBottomSheet(expandSheet: $isExpanded, activeSession: activeSession, animation: animation)
                        .transition(.asymmetric(insertion: .identity, removal: .offset(y: -5)))
                }
            } else {
                VStack {
                    switch selectedTab {
                    case .progress:
                        ProgressView()
                    case .start:
                        CreatePiece()
                    case .profile:
                        Profile(isSignedIn: $isSignedIn)
                    }
                }
                .environmentObject(viewModel)

                if !isExpanded && !keyboardResponder.isKeyboardVisible {
                    TabBar(selectedTab: $selectedTab, expandedSheet: $isExpanded, animation: animation)
                        .padding(0.0)
                        .environmentObject(viewModel)
                        .animation(.easeInOut(duration: 0.9), value: keyboardResponder.isKeyboardVisible)
                        .onAppear {
                            Task {
                                do {
                                    viewModel.activeSession = await viewModel.fetchCurrentActiveSession()
                                }
                            }
                        }
                }
            }
        } else {
            SignIn(isSignedIn: $isSignedIn)
        }
    }
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Initialize your view model
//        let viewModel = PracticeSessionViewModel()
//        viewModel.activeSession = PracticeSession.example()
//
//        // Pass the view model and a constant binding to ContentView
//        ContentView(isSignedIn: .constant(true), viewModel: viewModel)
//    }
// }

#Preview {
    let vm = PracticeSessionViewModel()
    vm.activeSession = PracticeSession.example()

    return ContentView(isSignedIn: .constant(true), viewModel: vm)
}
