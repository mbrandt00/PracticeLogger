//
//  BottomSheet.swift
//  PracticeLogger - State-Driven Version
//
//  Created by Michael Brandt on 2/16/25.
//
import ApolloGQL
import SwiftUI

struct BottomSheet: View {
    var animation: Namespace.ID
    @Binding var isExpanded: Bool
    @State private var elapsedTime: String = "00:00"
    @State var animateContent = false
    @State var offsetY: CGFloat = 0
    var activeSession: PracticeSessionDetails
    @EnvironmentObject var sessionManager: PracticeSessionViewModel

    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let safeArea = proxy.safeAreaInsets
            let denominator = max(size.height * 0.5, 1)
            let dragProgress = 1.0 - (offsetY / denominator)
            let cornerProgress = max(0, dragProgress)

            ZStack {
                // Background
                RoundedRectangle(
                    cornerRadius: isExpanded ? (animateContent ? 25 * cornerProgress : 25) : 12,
                    style: .continuous
                )
                .fill(.ultraThickMaterial)
                .overlay {
                    RoundedRectangle(
                        cornerRadius: isExpanded ? (animateContent ? 25 * cornerProgress : 25) : 12,
                        style: .continuous
                    )
                    .fill(Color.gray.opacity(0.3))
                    .opacity(isExpanded && animateContent ? 1 : 0)
                }
                .matchedGeometryEffect(id: "BGVIEW", in: animation)

                // Content
                VStack(spacing: 15) {
                    // Drag indicator - only show when expanded
                    if isExpanded {
                        Capsule()
                            .fill(.gray)
                            .frame(width: 40, height: 5)
                            .opacity(animateContent ? cornerProgress : 0)
                            .offset(y: animateContent ? 0 : size.height)
                            .clipped()
                    }

                    // Main content
                    if isExpanded {
                        // Expanded content
                        Text(activeSession.piece.workName)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .lineLimit(2)
                            .foregroundColor(.secondary)
                            .matchedGeometryEffect(id: "workName", in: animation)
                            .padding(.vertical, size.height < 700 ? 10 : 30)
                            .offset(y: animateContent ? 0 : size.height)

                        Spacer()
                    } else {
                        // Collapsed content
                        HStack(spacing: 0) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(elapsedTime)
                                    .font(.headline.bold())

                                Text(activeSession.piece.workName)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                                    .lineLimit(2)
                                    .foregroundColor(.secondary)
                                    .matchedGeometryEffect(id: "workName", in: animation)

                                HStack {
                                    if let movement = activeSession.movement {
                                        if let roman = movement.number?.toRomanNumeral() {
                                            Text(roman)
                                        }
                                        Text(movement.name ?? "")
                                    }

                                    if let composer = activeSession.piece.composer?.name {
                                        if activeSession.movement?.name != nil {
                                            Divider()
                                        }
                                        Text(composer)
                                    }
                                }
                                .font(.caption2)
                                .foregroundColor(.secondary)
                                .lineLimit(1)
                            }
                            .frame(maxWidth: .infinity, alignment: .bottomLeading)
                            .font(.system(size: 12, design: .serif))

                            Button {
                                Task { await sessionManager.stopSession() }
                            } label: {
                                Image(systemName: "stop.fill")
                                    .font(.title2)
                                    .foregroundColor(.primary)
                                    .padding(.trailing, 20)
                            }
                        }
                        .padding()
                    }
                }
                .padding(.top, isExpanded ? safeArea.top + (safeArea.bottom == 0 ? 10 : 0) : 0)
                .padding(.bottom, isExpanded ? (safeArea.bottom == 0 ? 10 : safeArea.bottom) : 0)
                .padding(.horizontal, isExpanded ? 25 : 0)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: isExpanded ? .top : .center)
                .clipped()
            }
            .contentShape(Rectangle())
            .offset(y: isExpanded ? offsetY : 0)
            .gesture(
                isExpanded ?
                    DragGesture()
                    .onChanged { value in
                        let translationY = value.translation.height
                        offsetY = max(translationY, 0)
                    }
                    .onEnded { value in
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if offsetY + (value.velocity.height * 0.3) > size.height * 0.4 {
                                isExpanded = false
                                animateContent = false
                            } else {
                                offsetY = 0
                            }
                        }
                    } : nil
            )
            .ignoresSafeArea(.all, edges: isExpanded ? .all : .bottom)
            .onAppear {
                updateElapsedTime()
                if isExpanded {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            animateContent = true
                        }
                    }
                }
            }
            .onChange(of: isExpanded) {
                if isExpanded {
                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            animateContent = true
                        }
                    }
                } else {
                    animateContent = false
                    offsetY = 0
                }
            }
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) { _ in
                updateElapsedTime()
            }
        }
        .frame(height: isExpanded ? nil : 70)
        .frame(maxHeight: isExpanded ? .infinity : 70)
        .clipped()
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(Color.accentColor.opacity(0.8))
                .frame(height: 2)
                .opacity(isExpanded ? 0 : 1)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.3)) {
                isExpanded.toggle()
            }
        }
    }

    // MARK: - Timer Logic

    private func updateElapsedTime() {
        let elapsedTimeInterval = Date().timeIntervalSince(activeSession.startTime)
        let hours = Int(elapsedTimeInterval) / 3600
        let minutes = (Int(elapsedTimeInterval) % 3600) / 60
        let seconds = Int(elapsedTimeInterval) % 60

        if hours > 0 {
            elapsedTime = String(format: "%d:%02d:%02d", hours, minutes, seconds)
        } else {
            elapsedTime = String(format: "%02d:%02d", minutes, seconds)
        }
    }
}
