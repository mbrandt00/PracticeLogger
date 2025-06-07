//
//  AnimatedQuarternotes.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 6/6/25.
//

import SwiftUI

struct AnimatedQuarternotes: View {
    @State private var animate1 = false
    @State private var animate2 = false
    @State private var animate3 = false

    var body: some View {
        ZStack {
            Image(systemName: "music.note")
                .font(.system(size: 10))
                .offset(x: -5, y: animate1 ? -2 : 2)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animate1)

            Image(systemName: "music.note")
                .font(.system(size: 10))
                .offset(x: 0, y: animate2 ? -2 : 2)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animate2)

            Image(systemName: "music.note")
                .font(.system(size: 10))
                .offset(x: 5, y: animate3 ? -2 : 2)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animate3)
        }
        .foregroundColor(.accentColor)
        .onAppear {
            animate1 = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { animate2 = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { animate3 = true }
        }
    }
}

struct AnimatedQuarternotes_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AnimatedQuarternotes()
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
