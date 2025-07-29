//
//  SplashScreenView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var logoScale: CGFloat = 0.3
    @State private var logoOpacity: Double = 0.0
    @State private var titleOpacity: Double = 0.0
    @State private var subtitleOpacity: Double = 0.0
    @State private var particlesOpacity: Double = 0.0
    @State private var particlesScale: CGFloat = 0.5
    @State private var gradientRotation: Double = 0.0
    @State private var showPulse: Bool = false
    @State private var animateParticles: Bool = false
    @State private var titleOffset: CGFloat = 50
    @State private var subtitleOffset: CGFloat = 30
    @State private var logoRotation: Double = 0.0
    @State private var showGlow: Bool = false
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("PrimaryColor").opacity(0.8),
                    Color("Accent").opacity(0.6),
                    Color("PrimaryDark").opacity(0.4)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .rotationEffect(.degrees(gradientRotation))
            .ignoresSafeArea()
            .onAppear {
                withAnimation(.linear(duration: 8.0).repeatForever(autoreverses: false)) {
                    gradientRotation = 360.0
                }
            }
            
            // Floating particles
            ForEach(0..<20, id: \.self) { index in
                Circle()
                    .fill(Color.white.opacity(0.3))
                    .frame(width: CGFloat.random(in: 4...12), height: CGFloat.random(in: 4...12))
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(particlesOpacity)
                    .scaleEffect(animateParticles ? 1.2 : 0.8)
                    .animation(
                        .easeInOut(duration: 2.0)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.1),
                        value: animateParticles
                    )
            }
            
            VStack(spacing: 30) {
                Spacer()
                
                // Main logo with animations
                ZStack {
                    // Pulse ring
                    Circle()
                        .stroke(Color.white.opacity(0.3), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(showPulse ? 1.5 : 1.0)
                        .opacity(showPulse ? 0.0 : 1.0)
                        .animation(.easeOut(duration: 2.0).repeatForever(autoreverses: false), value: showPulse)
                    
                    // App icon
                    Image(systemName: "target.fill")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                        .scaleEffect(logoScale)
                        .opacity(logoOpacity)
                        .rotationEffect(.degrees(logoRotation))
                        .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                        .overlay(
                            Circle()
                                .fill(Color.white.opacity(0.2))
                                .blur(radius: showGlow ? 20 : 0)
                                .scaleEffect(showGlow ? 1.5 : 0.8)
                                .opacity(showGlow ? 0.6 : 0.0)
                                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: showGlow)
                        )
                }
                
                // App title
                Text("Challengely")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .opacity(titleOpacity)
                    .offset(y: titleOffset)
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                
                // Subtitle
                Text("Transform your daily routine")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                    .opacity(subtitleOpacity)
                    .offset(y: subtitleOffset)
                    .multilineTextAlignment(.center)
                    .shadow(color: Color.black.opacity(0.2), radius: 3, x: 0, y: 1)
                
                Spacer()
                
                // Loading indicator
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color.white)
                            .frame(width: 8, height: 8)
                            .scaleEffect(showPulse ? 1.2 : 0.8)
                            .opacity(showPulse ? 0.6 : 1.0)
                            .animation(
                                .easeInOut(duration: 0.8)
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.2),
                                value: showPulse
                            )
                    }
                }
                .opacity(subtitleOpacity)
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Start pulse animation
        showPulse = true
        showGlow = true
        
        // Initial haptic feedback
        HapticManager.shared.impact(style: .light)
        
        // Animate logo entrance with rotation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.3).delay(0.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
            logoRotation = 360.0
        }
        
        // Logo haptic feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            HapticManager.shared.impact(style: .medium)
        }
        
        // Animate title entrance with slide
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6)) {
            titleOpacity = 1.0
            titleOffset = 0
        }
        
        // Title haptic feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            HapticManager.shared.impact(style: .light)
        }
        
        // Animate subtitle entrance with slide
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.9)) {
            subtitleOpacity = 1.0
            subtitleOffset = 0
        }
        
        // Animate particles
        withAnimation(.easeInOut(duration: 1.0).delay(1.2)) {
            particlesOpacity = 1.0
            particlesScale = 1.0
            animateParticles = true
        }
        
        // Complete splash screen after animations
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            // Final haptic feedback
            HapticManager.shared.notification(type: .success)
            
            withAnimation(.easeInOut(duration: 0.8)) {
                logoOpacity = 0.0
                titleOpacity = 0.0
                subtitleOpacity = 0.0
                particlesOpacity = 0.0
                titleOffset = -50
                subtitleOffset = -30
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                onComplete()
            }
        }
    }
}

#Preview {
    SplashScreenView {
        print("Splash screen completed")
    }
} 