//
//  SecondaryButtonStyle.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary, lineWidth: 2)
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            )
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}
