//
//  WelcomeStepView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct WelcomeStepView: View {
    @State private var animateIcon = false
    @State private var showQuote = false
    
    private let quotes = [
        "The only way to do great work is to love what you do. - Steve Jobs",
        "Growth is the only evidence of life. - John Henry Newman",
        "Every day is a new beginning. Take a deep breath and start again. - Anonymous"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            // Animated icon
            Image(systemName: Constants.SystemImages.welcomeIcon)
                .font(.system(size: 60, weight: .medium))
                .foregroundColor(.primary)
                .scaleEffect(animateIcon ? 1.1 : 1.0)
                .rotationEffect(.degrees(animateIcon ? 5 : 0))
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
                .onAppear {
                    animateIcon = true
                }
            
            VStack(spacing: 16) {
                Text(Constants.Onboarding.welcomeTitle)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text(Constants.Onboarding.welcomeSubtitle)
                    .font(.body)
                    .foregroundColor(.subtext)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // Motivational quote
                if showQuote {
                    Text(quotes.randomElement() ?? quotes[0])
                        .font(.caption)
                        .foregroundColor(.subtext)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(.top, 50)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showQuote = true
                }
            }
        }
    }
}
