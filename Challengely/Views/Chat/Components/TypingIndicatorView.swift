//
//  TypingIndicatorView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI


struct TypingIndicatorView: View {
    @State private var dotOffset1: CGFloat = 0
    @State private var dotOffset2: CGFloat = 0
    @State private var dotOffset3: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            // Assistant avatar
            Image(systemName: "brain.head.profile")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color("PrimaryColor"), Color("Accent")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
            
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 8, height: 8)
                        .offset(y: index == 0 ? dotOffset1 : index == 1 ? dotOffset2 : dotOffset3)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color("Card"))
            )
            
            Spacer(minLength: 60)
        }
        .onAppear {
            startTypingAnimation()
        }
    }
    
    private func startTypingAnimation() {
        let animation = Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)
        
        withAnimation(animation.delay(0.0)) {
            dotOffset1 = -5
        }
        
        withAnimation(animation.delay(0.2)) {
            dotOffset2 = -5
        }
        
        withAnimation(animation.delay(0.4)) {
            dotOffset3 = -5
        }
    }
}
