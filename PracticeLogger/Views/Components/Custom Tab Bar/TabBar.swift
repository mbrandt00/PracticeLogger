//
//  TabBar.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import ApolloGQL
import Combine
import SwiftUI

struct TabBar: View {
    @Binding var selectedTab: Tabs
    @Binding var expandedSheet: Bool
    @EnvironmentObject var sessionManager: PracticeSessionViewModel
    var animation: Namespace.ID
    @ObservedObject private var keyboardResponder = KeyboardResponder()

    var body: some View {
//        .safeAreaInset(edge: .bottom) {
//            if let activeSession = sessionManager.activeSession {
//                BottomSheet(animation: animation, expandedSheet: $expandedSheet, activeSession: activeSession)
//                    .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .move(edge: .bottom).combined(with: .opacity)))
//                    .animation(.easeInOut(duration: 0.3))
//            }
//        }
//        .frame(height: sessionManager.activeSession != nil ? 90 : 35)
//        .toolbarBackground(.ultraThickMaterial, for: .tabBar)
//        .toolbar(expandedSheet ? .hidden : .visible, for: .tabBar)
//        .opacity(keyboardResponder.isKeyboardVisible ? 0 : 1)
//        .offset(y: keyboardResponder.isKeyboardVisible ? 100 : 0)
//        .animation(.easeInOut, value: keyboardResponder.isKeyboardVisible)
        Text("body")
    }
}

//
// #Preview {
//    @Namespace var animation
//    let vm = PracticeSessionViewModel()
//    vm.activeSession = PracticeSession.inProgressExample
//    return TabBar(selectedTab: .constant(.start), expandedSheet: .constant(false), animation: animation).environmentObject(vm).preferredColorScheme(.light)
// }
//
// #Preview {
//    let vm = PracticeSessionViewModel()
//    vm.activeSession = PracticeSession.inProgressExample
//
//    @Namespace var animation
//    return TabBar(selectedTab: .constant(.start), expandedSheet: .constant(false), animation: animation).environmentObject(vm).preferredColorScheme(.dark)
// }
