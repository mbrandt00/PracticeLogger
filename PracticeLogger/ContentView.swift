//  ContentView.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/23/24.
//

import Apollo
import ApolloAPI
import ApolloGQL
import KeychainAccess
import MusicKit
import SwiftUI

enum Tabs: String {
    case practice = "Practice"
    case settings = "Settings"
}

struct ContentView: View {
    @Binding var isSignedIn: Bool
    @State private var selectedTab: Tabs = .practice
    @Namespace private var animation
    @StateObject private var practiceSessionViewModel = PracticeSessionViewModel()
    @StateObject private var keyboardResponder = KeyboardResponder()
    @StateObject private var uiState = UIState()
    @Environment(\.scenePhase) private var scenePhase

    init(isSignedIn: Binding<Bool>, practiceSessionViewModel: PracticeSessionViewModel = PracticeSessionViewModel()) {
        _isSignedIn = isSignedIn
        _practiceSessionViewModel = StateObject(wrappedValue: practiceSessionViewModel)
    }

    private var shouldShowBottomSheet: Bool {
        practiceSessionViewModel.activeSession != nil &&
            !keyboardResponder.isKeyboardVisible &&
            !uiState.isScreenBusy
    }

    private let bottomSheetHeight: CGFloat = 70
    private let standardTabBarHeight: CGFloat = 49

    var body: some View {
        if isSignedIn {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    TabView(selection: $selectedTab) {
                        RecentPracticeSessions(practiceSessionViewModel: practiceSessionViewModel)
                            .padding(.bottom, shouldShowBottomSheet ? bottomSheetHeight : 0)
                            .tabItem { Label("Practice", systemImage: "metronome") }
                            .tag(Tabs.practice)

                        Settings(isSignedIn: $isSignedIn)
                            .padding(.bottom, shouldShowBottomSheet ? bottomSheetHeight : 0)
                            .animation(.easeInOut(duration: 0.25), value: shouldShowBottomSheet)
                            .tabItem { Label("Settings", systemImage: "gear") }
                            .tag(Tabs.settings)
                    }

                    // Conditional BottomSheet Overlay Layer
                    if shouldShowBottomSheet {
                        BottomSheet(
                            animation: animation,
                            expandedSheet: .constant(false),
                            activeSession: practiceSessionViewModel.activeSession!
                        )
                        .padding(.bottom, geometry.safeAreaInsets.bottom + standardTabBarHeight)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    }
                }
                .animation(.easeInOut(duration: 0.25), value: shouldShowBottomSheet)
                .edgesIgnoringSafeArea(.bottom)
            }
            .onAppear {
                Task {
                    do {
                        let token = try await Database.client.auth.session.accessToken
                        let keychain = Keychain(
                            service: "com.brandt.practiceLogger",
                            accessGroup: "PZARYFA5MD.michaelbrandt.PracticeLogger"
                        )
                        try? keychain.set(token, key: "supabase_access_token")

                        practiceSessionViewModel.activeSession = try await practiceSessionViewModel.fetchCurrentActiveSession()
                    } catch {
                        print("Something went wrong in on appear: \(error.localizedDescription)")
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
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    Task {
                        do {
                            practiceSessionViewModel.activeSession = try await practiceSessionViewModel.fetchCurrentActiveSession()
                        } catch {
                            print("Failed to refresh session on foreground: \(error)")
                        }
                    }
                }
            }
            .environmentObject(practiceSessionViewModel)
            .environmentObject(keyboardResponder)
            .environmentObject(uiState)
            .toolbarBackground(.ultraThickMaterial, for: .tabBar)
        } else {
            SignIn(isSignedIn: $isSignedIn)
        }
    }
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        let practiceSessionViewModel = PracticeSessionViewModel()
//        practiceSessionViewModel.setActiveSessionForPreview()
//
//        return ContentView(isSignedIn: .constant(true), practiceSessionViewModel: practiceSessionViewModel)
//    }
// }
