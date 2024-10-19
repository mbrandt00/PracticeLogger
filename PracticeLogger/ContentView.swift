//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import Apollo
import ApolloAPI
import ApolloGQL
import MusicKit
import SwiftUI

enum Tabs: String {
    case progress = "Progress"
    case practice = "Practice"
    case profile = "Profile"
}

struct ContentView: View {
    @Binding var isSignedIn: Bool
    @State private var selectedTab: Tabs = .practice
    @Namespace private var animation
    @StateObject private var practiceSessionViewModel = PracticeSessionViewModel()
    @State private var keyboardResponder = KeyboardResponder()
    @State var searchIsFocused = false

    init(isSignedIn: Binding<Bool>, practiceSessionViewModel: PracticeSessionViewModel = PracticeSessionViewModel()) {
        self._isSignedIn = isSignedIn
        self._practiceSessionViewModel = StateObject(wrappedValue: practiceSessionViewModel)
    }

    var body: some View {
        if isSignedIn {
            ZStack {
                TabView(selection: $selectedTab) {
                    ProgressView()
                        .tabItem {
                            Label("Progress", systemImage: "chart.xyaxis.line")
                        }
                        .tag(Tabs.progress)

                    RecentPracticeSessions(practiceSessionViewModel: practiceSessionViewModel)
                        .tabItem {
                            Label("Practice", systemImage: "metronome")
                        }
                        .tag(Tabs.practice)

                    Profile(isSignedIn: $isSignedIn)
                        .tabItem {
                            Label("Profile", systemImage: "person")
                        }
                        .tag(Tabs.profile)
                }

                if let activeSession = practiceSessionViewModel.activeSession {
                    GeometryReader { geometry in
                        VStack {
                            Spacer()
                            BottomSheet(
                                animation: animation,
                                expandedSheet: .constant(false),
                                activeSession: activeSession
                            )
                            .padding(.bottom, geometry.safeAreaInsets.bottom + 49)
                            .transition(.move(edge: .bottom))
                        }
                        .edgesIgnoringSafeArea(.bottom)
                    }
                }
            }
            .onAppear {
                Task {
                    do {
                        practiceSessionViewModel.activeSession = await practiceSessionViewModel.fetchCurrentActiveSession()
                    }
                }
                // correct the transparency bug for Tab bars
                let tabBarAppearance = UITabBarAppearance()
                tabBarAppearance.configureWithOpaqueBackground()
                UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
                // correct the transparency bug for Navigation bars
                let navigationBarAppearance = UINavigationBarAppearance()
                navigationBarAppearance.configureWithOpaqueBackground()
                UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
            }
            .environmentObject(practiceSessionViewModel)
            .environmentObject(keyboardResponder)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
        } else {
            SignIn(isSignedIn: $isSignedIn)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let practiceSessionViewModel = PracticeSessionViewModel()
        practiceSessionViewModel.setActiveSessionForPreview()

        return ContentView(isSignedIn: .constant(true), practiceSessionViewModel: practiceSessionViewModel)
    }
}
