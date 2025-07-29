//
//  SplashScreenView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

/// SplashScreenView provides an engaging launch experience with animated elements
struct SplashScreenView: View {
    // MARK: - Animation State Properties
    
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
    @State private var animateWaves: Bool = false
    
    let onComplete: () -> Void
    
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("AppPrimaryColor").opacity(0.15),
                    Color("Accent").opacity(0.10),
                    Color("PrimaryDark").opacity(0.08),
                    Color("Background").opacity(0.95)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Animated background elements
            ZStack {
                // Wave layers
                ForEach(0..<3) { index in
                    WaveShape(frequency: 1.5 + Double(index) * 0.5, amplitude: 50 + CGFloat(index) * 20)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color("AppPrimaryColor").opacity(0.2 - Double(index) * 0.05),
                                    Color("Accent").opacity(0.15 - Double(index) * 0.03),
                                    Color("Success").opacity(0.1 - Double(index) * 0.02)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .offset(y: animateWaves ? CGFloat(index) * 100 + 20 : CGFloat(index) * 100 - 20)
                        .animation(
                            .easeInOut(duration: 4.0 + Double(index))
                            .repeatForever(autoreverses: true)
                            .delay(Double(index) * 0.5),
                            value: animateWaves
                        )
                }
                
                // Floating geometric shapes
                ForEach(0..<8) { index in
                    Group {
                        if index % 3 == 0 {
                            Circle()
                                .fill(Color("AppPrimaryColor").opacity(0.08))
                                .frame(width: CGFloat.random(in: 20...60), height: CGFloat.random(in: 20...60))
                        } else if index % 3 == 1 {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color("Accent").opacity(0.06))
                                .frame(width: CGFloat.random(in: 30...50), height: CGFloat.random(in: 30...50))
                        } else {
                            SplashTriangle()
                                .fill(Color("Success").opacity(0.05))
                                .frame(width: CGFloat.random(in: 25...45), height: CGFloat.random(in: 25...45))
                        }
                    }
                    .position(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    )
                    .opacity(particlesOpacity)
                    .scaleEffect(animateParticles ? 1.3 : 0.7)
                    .rotationEffect(.degrees(animateParticles ? 360 : 0))
                    .animation(
                        .easeInOut(duration: 3.0 + Double(index) * 0.5)
                        .repeatForever(autoreverses: true)
                        .delay(Double(index) * 0.3),
                        value: animateParticles
                    )
                }
            }
            .ignoresSafeArea()
            
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
                
                // Main logo with trophy design
                ZStack {
                    // Pulse ring
                    Circle()
                        .stroke(Color("AppPrimaryColor").opacity(0.4), lineWidth: 2)
                        .frame(width: 120, height: 120)
                        .scaleEffect(showPulse ? 1.5 : 1.0)
                        .opacity(showPulse ? 0.0 : 1.0)
                        .animation(.easeOut(duration: 2.0).repeatForever(autoreverses: false), value: showPulse)
                    
                    // Trophy icon
                    ZStack {
                        // Trophy base
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color("AppPrimaryColor"))
                            .frame(width: 40, height: 60)
                            .offset(y: 15)
                        
                        // Trophy handles
                        ForEach(0..<2) { index in
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color("AppPrimaryColor"))
                                .frame(width: 8, height: 20)
                                .offset(x: index == 0 ? -24 : 24, y: 5)
                        }
                        
                        // Trophy top
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color("AppPrimaryColor"))
                            .frame(width: 50, height: 35)
                            .offset(y: -10)
                        
                        // Star on top
                        Image(systemName: "star.fill")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(Color("ConfettiYellow"))
                            .offset(y: -25)
                            .scaleEffect(showGlow ? 1.3 : 1.0)
                            .rotationEffect(.degrees(showGlow ? 360 : 0))
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: showGlow)
                        
                        // Orbiting particles
                        ForEach(0..<6) { index in
                            Circle()
                                .fill(Color("Accent"))
                                .frame(width: 4, height: 4)
                                .offset(
                                    x: CGFloat(cos(Double(index) * .pi / 3)) * 35,
                                    y: CGFloat(sin(Double(index) * .pi / 3)) * 35
                                )
                                .opacity(showGlow ? 0.8 : 0.0)
                                .scaleEffect(showGlow ? 1.2 : 0.5)
                                .animation(
                                    .easeInOut(duration: 1.5)
                                    .repeatForever(autoreverses: true)
                                    .delay(Double(index) * 0.2),
                                    value: showGlow
                                )
                        }
                    }
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)
                    .rotationEffect(.degrees(logoRotation))
                    .shadow(color: Color("AppPrimaryColor").opacity(0.3), radius: 10, x: 0, y: 5)
                    .overlay(
                        Circle()
                            .fill(Color("AppPrimaryColor").opacity(0.2))
                            .blur(radius: showGlow ? 20 : 0)
                            .scaleEffect(showGlow ? 1.5 : 0.8)
                            .opacity(showGlow ? 0.6 : 0.0)
                            .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: showGlow)
                    )
                }
                
                // App title
                Text(Constants.App.name)
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(Color("TextLabel"))
                    .opacity(titleOpacity)
                    .offset(y: titleOffset)
                    .shadow(color: Color("AppPrimaryColor").opacity(0.2), radius: 5, x: 0, y: 2)
                
                // App subtitle
                Text(Constants.App.tagline)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color("Subtext"))
                    .opacity(subtitleOpacity)
                    .offset(y: subtitleOffset)
                    .multilineTextAlignment(.center)
                    .shadow(color: Color("AppPrimaryColor").opacity(0.1), radius: 3, x: 0, y: 1)
                
                Spacer()
                
                // Loading indicator
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { index in
                        Circle()
                            .fill(Color("AppPrimaryColor"))
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
    
    // MARK: - Animation Control
    
    private func startAnimations() {
        // Start continuous animations
        showPulse = true
        showGlow = true
        animateWaves = true
        
        // Initial haptic feedback
        HapticManager.shared.impact(style: .light)
        
        // Logo entrance animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0.3).delay(0.2)) {
            logoScale = 1.0
            logoOpacity = 1.0
            logoRotation = 360.0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            HapticManager.shared.impact(style: .medium)
        }
        
        // Title entrance animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.6)) {
            titleOpacity = 1.0
            titleOffset = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            HapticManager.shared.impact(style: .light)
        }
        
        // Subtitle entrance animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.9)) {
            subtitleOpacity = 1.0
            subtitleOffset = 0
        }
        
        // Particle animations
        withAnimation(.easeInOut(duration: 1.0).delay(1.2)) {
            particlesOpacity = 1.0
            particlesScale = 1.0
            animateParticles = true
        }
        
        // Complete splash screen after 3.5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.Animation.splash) {
            HapticManager.shared.notification(type: .success)
            
            // Fade-out animation
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

// MARK: - Custom Shapes

struct WaveShape: Shape {
    let frequency: Double
    let amplitude: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height / 2
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let relativeX = x / width
            let sine = sin(relativeX * frequency * 2 * .pi)
            let y = midHeight + amplitude * CGFloat(sine)
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

struct SplashTriangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
} 
