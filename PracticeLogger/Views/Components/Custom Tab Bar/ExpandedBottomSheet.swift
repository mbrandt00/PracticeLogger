//
//  ExpandedBottomSheet.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/6/24.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    @State private var animateContent: Bool = false
    var animation: Namespace.ID
    var activeSession: PracticeSession
    @Binding var expandedSheet: Bool
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            ZStack {
                Rectangle()
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        Rectangle()
                            .fill(.gray)
                            .opacity(animateContent ? 1 : 0)
                    })
                    .overlay(alignment: .top) {
                        MusicInfo(expandedSheet: $expandedSheet, activeSession: activeSession, animation: animation)
                        /// Disable interactions
                            .allowsHitTesting(false)
                            .opacity(animateContent ? 0 : 1)
                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)
                VStack(spacing: 15 ) {
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? 1 : 0)

                    GeometryReader {
                        let size = $0.size
                        Image(systemName: "timer")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    .matchedGeometryEffect(id: /*@START_MENU_TOKEN@*/"ID"/*@END_MENU_TOKEN@*/, in: animation)
                    .frame(height: size.width - 50)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .onTapGesture {
                    /// for testing
                    withAnimation(.easeInOut(duration: 0.3) ) {
                        expandedSheet = false
                        animateContent = false
                    }
                }

            }

            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
}

#Preview {
    ContentView().preferredColorScheme(.light)
}
