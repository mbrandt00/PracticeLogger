//
//  ExpandedBottomSheet.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 7/6/24.
//

import SwiftUI

struct ExpandedBottomSheet: View {
    @Binding var expandSheet: Bool
    var activeSession: PracticeSession
    var animation: Namespace.ID
    /// View Properties
    @State private var animateContent: Bool = false
    @State private var offsetY: CGFloat = 0
    var body: some View {
        GeometryReader {
            let size = $0.size
            let safeArea = $0.safeAreaInsets
            let dragProgress = 1.0 - (offsetY / (size.height * 0.5))
            let cornerProgress = max(0, dragProgress)

            ZStack {
                /// Making it as Rounded Rectangle with Device Corner Radius
                RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius * cornerProgress : 0, style: .continuous)
                    .fill(.ultraThickMaterial)
                    .overlay(content: {
                        RoundedRectangle(cornerRadius: animateContent ? deviceCornerRadius * cornerProgress : 0, style: .continuous)
                            .fill(Color.gray.opacity(0.3))
                            .opacity(animateContent ? 1 : 0)
                    })
//                    .overlay(alignment: .top) {
//                        MusicInfo(expandedSheet: $expandSheet, activeSession: PracticeSession.example(), animation: animation)
//                            /// Disabling Interaction (Since it's not Necessary Here)
//                            .allowsHitTesting(false)
//                            .opacity(animateContent ? 0 : 1)
//                    }
                    .matchedGeometryEffect(id: "BGVIEW", in: animation)

                VStack(spacing: 15) {
                    /// Grab Indicator
                    Capsule()
                        .fill(.gray)
                        .frame(width: 40, height: 5)
                        .opacity(animateContent ? cornerProgress : 0)
                        /// Mathing with Slide Animation
                        .offset(y: animateContent ? 0 : size.height)
                        .clipped()

                    /// Artwork Hero View
                    GeometryReader {
                        let size = $0.size

                        Image("Artwork")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: animateContent ? 15 : 5, style: .continuous))
                    }
                    .matchedGeometryEffect(id: "ARTWORK", in: animation)
                    /// For Square Artwork Image
                    .frame(height: size.width - 50)
                    /// For Smaller Devices the padding will be 10 and for larger devices the padding will be 30
                    .padding(.vertical, size.height < 700 ? 10 : 30)
                    /// Player View
                    //                    PlayerView(size)
                    /// Moving it From Bottom
                    .offset(y: animateContent ? 0 : size.height)
                }
                .padding(.top, safeArea.top + (safeArea.bottom == 0 ? 10 : 0))
                .padding(.bottom, safeArea.bottom == 0 ? 10 : safeArea.bottom)
                .padding(.horizontal, 25)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .clipped()
            }
            .contentShape(Rectangle())
            .offset(y: offsetY)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        let translationY = value.translation.height
                        offsetY = (translationY > 0 ? translationY : 0)
                    }.onEnded { value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if (offsetY + (value.velocity.height * 0.3)) > size.height * 0.4 {
                                expandSheet = false
                                animateContent = false
                            } else {
                                offsetY = .zero
                            }
                        }
                    }
            )
            .ignoresSafeArea(.container, edges: .all)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.35)) {
                animateContent = true
            }
        }
    }
}

struct ExpandedBottomSheet_Previews: PreviewProvider {
    @Namespace static var animation

    static var previews: some View {
        let activeSession = PracticeSession.inProgressExample
        ExpandedBottomSheet(
            expandSheet: .constant(true),
            activeSession: activeSession,
            animation: animation
        ).preferredColorScheme(.dark)
    }
}
