//
//  TabBarButton.swift
//  PracticeLogger
//
//  Created by Michael Brandt on 2/24/24.
//

import SwiftUI

struct TabBarButton: View {
    var imageName: String
    var buttonText: String
    var isActive: Bool

    var body: some View {
        GeometryReader { geo in
            if isActive {
                Rectangle()
                    .frame(width: geo.size.width/2, height: 4)
                    .padding(.leading, geo.size.width/4)
            }

            VStack {
                Image(systemName: imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                Text(buttonText).font(.headline)
            }
            .frame(width: geo.size.width, height: geo.size.height)
            .foregroundColor(isActive ? Color.theme.accent : Color.theme.gray)
        }
    }
}

#Preview {
    TabBarButton(imageName: "chart.xyaxis.line", buttonText: "Progress", isActive: true).previewLayout(.sizeThatFits)
}
