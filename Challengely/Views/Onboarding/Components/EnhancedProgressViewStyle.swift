//
//  EnhancedProgressViewStyle.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct EnhancedProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primary.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primary, Color.accentColor]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
                    .frame(height: 8)
                    .animation(.easeInOut(duration: 0.5), value: configuration.fractionCompleted)
            }
        }
        .frame(height: 8)
        .shadow(color: Color.primary.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}
