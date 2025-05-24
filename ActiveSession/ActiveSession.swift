//
//  ActiveSession.swift
//  ActiveSession
//
//  Created by Michael Brandt on 5/13/25.
//

import ActivityKit
import SwiftUI
import WidgetKit

struct TimerActivityView: View {
    let context: ActivityViewContext<LiveActivityAttributes>

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                HStack(spacing: 4) {
                    Image(systemName: "music.note")
                        .foregroundColor(.purple)
                        .imageScale(.medium)

                    Text("Practice")
                        .font(.system(size: 15, weight: .semibold))
                }

                Spacer()

                sessionTimer(start: context.state.startTime, end: context.state.endTime)
            }

            Text(context.attributes.pieceName)
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)
                .truncationMode(.tail)
                .padding(.top, 2)

            if let movementName = context.attributes.movementName,
               let movementNumber = context.attributes.movementNumber,
               let romanNumeral = movementNumber.toRomanNumeral()
            {
                Text("\(romanNumeral). \(movementName)")
                    .font(.system(size: 14))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .layoutPriority(1)
            }

            Spacer()
                .frame(height: 8)

            Button(intent: EndPracticeSessionIntent()) {
                Label("End Session", systemImage: "xmark.circle.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.red)
            }
            .cornerRadius(12)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

@ViewBuilder
func sessionTimer(start: Date, end: Date?) -> some View {
    if let end = end {
        let duration = Duration(secondsComponent: Int64(Int(end.timeIntervalSince(start))), attosecondsComponent: 0)
        Text(duration.formatted(.units()))
            .font(.system(size: 15, design: .monospaced))
            .fontWeight(.medium)
            .monospacedDigit()
    } else {
        Text(start, style: .timer)
            .font(.system(size: 15, design: .monospaced))
            .fontWeight(.medium)
            .monospacedDigit()
    }
}

struct ActiveSession: Widget {
    let kind: String = "ActiveSession"

    var body: some WidgetConfiguration {
        ActivityConfiguration(for: LiveActivityAttributes.self) { context in
            // Lock screen/banner UI
            TimerActivityView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI
                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(context.attributes.pieceName)
                            .font(.system(size: 16, weight: .semibold))
                            .multilineTextAlignment(.leading)

                        if let movementName = context.attributes.movementName,
                           let movementNumber = context.attributes.movementNumber,
                           let romanNumeral = movementNumber.toRomanNumeral()
                        {
                            Text("\(romanNumeral). \(movementName)")
                                .font(.system(size: 13))
                                .foregroundColor(.secondary)
                        }
                    }
                }

                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: "music.note")
                        .foregroundColor(.purple)
                        .imageScale(.large)
                        .frame(width: 40)
                        .padding(.leading, 4)
                }

                DynamicIslandExpandedRegion(.trailing) {
                    sessionTimer(start: context.state.startTime, end: context.state.endTime)
                        .font(.system(size: 15, design: .monospaced))
                        .fontWeight(.medium)
                        .monospacedDigit()
                        .frame(width: 55, alignment: .trailing)
                        .padding(.trailing, 6)
                }

                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Button {
                            // Action to pause practice session
                        } label: {
                            Label("Pause", systemImage: "pause.circle.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.orange)
                        }
                        .buttonStyle(.plain)

                        Spacer()

                        Button(intent: EndPracticeSessionIntent()) {
                            Label("End Session", systemImage: "xmark.circle.fill")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.red)
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal, 8)
                    .padding(.bottom, 4)
                }
            } compactLeading: {
                Image(systemName: "music.note")
                    .foregroundColor(.purple)
                    .frame(width: 20)
                    .padding(.leading, 4)
            } compactTrailing: {
                Text(context.state.startTime, style: .timer)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .frame(width: 40)
            } minimal: {
                Image(systemName: "music.note")
                    .foregroundColor(.purple)
            }
        }
    }
}

@available(iOS 16.2, *)
struct ActiveSessionLiveActivityPreviews: PreviewProvider {
    static let attributes = LiveActivityAttributes(
        pieceName: "Hammerklavier",
        movementName: "Introduzione: Largo... Allegro – Fuga: Allegro risoluto",
        movementNumber: 4
    )

    static let contentState = LiveActivityAttributes.ContentState(
        startTime: Date().addingTimeInterval(-300),
        endTime: Date()
    )

    static var previews: some View {
        Group {
            attributes.previewContext(contentState, viewKind: .content)
                .previewDisplayName("Lock Screen")

            attributes.previewContext(contentState, viewKind: .dynamicIsland(.expanded))
                .previewDisplayName("Dynamic Island Expanded")

            attributes.previewContext(contentState, viewKind: .dynamicIsland(.compact))
                .previewDisplayName("Dynamic Island Compact")

            attributes.previewContext(contentState, viewKind: .dynamicIsland(.minimal))
                .previewDisplayName("Dynamic Island Minimal")
        }
    }
}
