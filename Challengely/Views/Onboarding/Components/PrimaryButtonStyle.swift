//
//  PrimaryButtonStyle.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("AppPrimaryColor"), Color("Accent")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            )
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Color("AppPrimaryColor").opacity(0.3), radius: 8, x: 0, y: 4)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
