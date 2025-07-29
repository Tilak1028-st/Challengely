import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var sparkles: [Sparkle] = []
    @State private var fireworks: [Firework] = []
    @State private var isAnimating = false
    @State private var burstScale: CGFloat = 0.0
    @State private var celebrationText = ""
    @State private var showText = false
    @State private var textScale: CGFloat = 0.5
    
    let colors: [Color] = [
        AppColor.appPrimary,
        AppColor.accent,
        AppColor.success,
        AppColor.confettiYellow,
        AppColor.challengeRed,
        AppColor.primaryDark,
        AppColor.userBubble,
        .white,
        .orange,
        .purple,
        .pink,
        .cyan,
        .mint
    ]
    
    var body: some View {
        ZStack {
            // Celebration background glow
            RadialGradient(
                gradient: Gradient(colors: [
                    AppColor.appPrimary.opacity(0.4),
                    AppColor.accent.opacity(0.3),
                    AppColor.success.opacity(0.2),
                    Color.clear
                ]),
                center: .center,
                startRadius: 0,
                endRadius: 200
            )
            .scaleEffect(burstScale)
            .opacity(burstScale > 0 ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.8), value: burstScale)
            
            // Fireworks
            ForEach(fireworks) { firework in
                FireworkView(firework: firework)
            }
            
            // Sparkles
            ForEach(sparkles) { sparkle in
                SparkleView(sparkle: sparkle)
            }
            
            // Confetti particles
            ForEach(particles) { particle in
                ConfettiParticleView(particle: particle)
            }
            
            // Celebration text
            if showText {
                Text(celebrationText)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, AppColor.confettiYellow, .white],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(textScale)
                    .opacity(showText ? 1.0 : 0.0)
                    .shadow(color: .black.opacity(0.5), radius: 5, x: 0, y: 2)
                    .animation(.spring(response: 0.8, dampingFraction: 0.6), value: textScale)
            }
        }
        .onAppear {
            createCelebration()
            startAnimation()
        }
    }
    
    private func createCelebration() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        // Create confetti particles
        particles = (0..<100).map { index in
            let angle = Double(index) * (2 * .pi / 100)
            let radius = CGFloat.random(in: 30...120)
            let startX = centerX + cos(angle) * radius
            let startY = centerY + sin(angle) * radius
            
            return ConfettiParticle(
                color: colors.randomElement() ?? .red,
                size: CGFloat.random(in: 4...18),
                position: CGPoint(x: startX, y: startY),
                opacity: 1.0,
                rotation: Double.random(in: 0...360),
                shape: ConfettiShape.allCases.randomElement() ?? .circle,
                velocity: CGVector(
                    dx: CGFloat.random(in: -250...250),
                    dy: CGFloat.random(in: -500...(-150))
                ),
                gravity: CGFloat.random(in: 400...700),
                wind: CGFloat.random(in: -80...80)
            )
        }
        
        // Create sparkles
        sparkles = (0..<50).map { _ in
            Sparkle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...screenWidth),
                    y: CGFloat.random(in: 0...screenHeight)
                ),
                color: colors.randomElement() ?? .white,
                size: CGFloat.random(in: 2...8),
                delay: Double.random(in: 0...2.0)
            )
        }
        
        // Create fireworks
        fireworks = (0..<5).map { index in
            Firework(
                position: CGPoint(
                    x: CGFloat.random(in: screenWidth * 0.2...screenWidth * 0.8),
                    y: CGFloat.random(in: screenHeight * 0.2...screenHeight * 0.8)
                ),
                color: colors.randomElement() ?? .white,
                delay: Double(index) * 0.5,
                particles: (0..<20).map { _ in
                    FireworkParticle(
                        color: colors.randomElement() ?? .white,
                        velocity: CGVector(
                            dx: CGFloat.random(in: -150...150),
                            dy: CGFloat.random(in: -150...150)
                        ),
                        position: .zero
                    )
                }
            )
        }
        
        // Set celebration text
        let texts = ["🎉 AMAZING!", "✨ INCREDIBLE!", "🚀 FANTASTIC!", "💪 YOU DID IT!", "🌟 BRILLIANT!"]
        celebrationText = texts.randomElement() ?? "🎉 CONGRATULATIONS!"
    }
    
    private func startAnimation() {
        isAnimating = true
        
        // Start burst effect
        withAnimation(.easeOut(duration: 0.5)) {
            burstScale = 1.0
        }
        
        // Show celebration text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6)) {
                showText = true
                textScale = 1.0
            }
        }
        
        // Animate particles with physics
        let animationDuration: Double = 5.0
        _ = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            let elapsed = Date().timeIntervalSince(timer.fireDate) + 0.016
            let progress = elapsed / animationDuration
            
            if progress >= 1.0 {
                timer.invalidate()
                isAnimating = false
                return
            }
            
            // Update particle physics
            for i in particles.indices {
                let particle = particles[i]
                
                // Apply physics
                let newX = particle.position.x + particle.velocity.dx * 0.016
                let newY = particle.position.y + particle.velocity.dy * 0.016
                
                // Apply gravity
                particles[i].velocity.dy += particle.gravity * 0.016
                
                // Apply wind
                particles[i].velocity.dx += particle.wind * 0.016
                
                // Update position
                particles[i].position = CGPoint(x: newX, y: newY)
                
                // Update rotation
                particles[i].rotation += 3.0
                
                // Fade out near the end
                if progress > 0.8 {
                    particles[i].opacity = 1.0 - ((progress - 0.8) / 0.2)
                }
            }
        }
        
        // Multiple haptic feedback for celebration
        HapticManager.shared.notification(type: .success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            HapticManager.shared.impact(style: .heavy)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            HapticManager.shared.impact(style: .medium)
        }
        
        // Cleanup celebration
        DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showText = false
                textScale = 0.5
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            withAnimation(.easeIn(duration: 0.5)) {
                burstScale = 0.0
            }
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        ConfettiView()
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var color: Color
    var size: CGFloat
    var position: CGPoint
    var opacity: Double
    var rotation: Double
    var shape: ConfettiShape
    var velocity: CGVector
    var gravity: CGFloat
    var wind: CGFloat
}

struct Sparkle: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var size: CGFloat
    var delay: Double
    var opacity: Double = 0.0
    var scale: CGFloat = 0.0
}

struct Firework: Identifiable {
    let id = UUID()
    var position: CGPoint
    var color: Color
    var delay: Double
    var particles: [FireworkParticle]
    var exploded: Bool = false
    var opacity: Double = 1.0
}

struct FireworkParticle: Identifiable {
    let id = UUID()
    var color: Color
    var velocity: CGVector
    var position: CGPoint = .zero
    var opacity: Double = 1.0
}

enum ConfettiShape: CaseIterable {
    case circle, square, triangle, star, diamond
}

struct ConfettiParticleView: View {
    let particle: ConfettiParticle
    
    var body: some View {
        Group {
            switch particle.shape {
            case .circle:
                Circle()
                    .fill(particle.color)
            case .square:
                Rectangle()
                    .fill(particle.color)
            case .triangle:
                Triangle()
                    .fill(particle.color)
            case .star:
                Star(points: 5)
                    .fill(particle.color)
            case .diamond:
                Diamond()
                    .fill(particle.color)
            }
        }
        .frame(width: particle.size, height: particle.size)
        .position(particle.position)
        .opacity(particle.opacity)
        .rotationEffect(.degrees(particle.rotation))
        .shadow(color: particle.color.opacity(0.5), radius: 2, x: 0, y: 1)
    }
}

struct SparkleView: View {
    let sparkle: Sparkle
    @State private var isAnimating = false
    
    var body: some View {
        Image(systemName: "sparkles")
            .font(.system(size: sparkle.size))
            .foregroundColor(sparkle.color)
            .position(sparkle.position)
            .opacity(isAnimating ? 1.0 : 0.0)
            .scaleEffect(isAnimating ? 1.2 : 0.0)
            .rotationEffect(.degrees(isAnimating ? 360 : 0))
            .animation(
                .easeInOut(duration: 1.5)
                .repeatForever(autoreverses: true)
                .delay(sparkle.delay),
                value: isAnimating
            )
            .onAppear {
                isAnimating = true
            }
    }
}

struct FireworkView: View {
    let firework: Firework
    @State private var isExploded = false
    @State private var particles: [FireworkParticle] = []
    @State private var particlePositions: [CGPoint] = []
    @State private var particleOpacities: [Double] = []
    
    var body: some View {
        ZStack {
            // Firework trail
            if !isExploded {
                Circle()
                    .fill(firework.color)
                    .frame(width: 4, height: 4)
                    .position(firework.position)
                    .opacity(firework.opacity)
            }
            
            // Exploded particles
            ForEach(Array(particles.enumerated()), id: \.element.id) { index, particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: 3, height: 3)
                    .position(particlePositions.indices.contains(index) ? particlePositions[index] : firework.position)
                    .opacity(particleOpacities.indices.contains(index) ? particleOpacities[index] : 1.0)
            }
        }
        .onAppear {
            // Start firework animation
            DispatchQueue.main.asyncAfter(deadline: .now() + firework.delay) {
                explodeFirework()
            }
        }
    }
    
    private func explodeFirework() {
        isExploded = true
        
        // Initialize particle arrays
        particles = firework.particles
        particlePositions = Array(repeating: firework.position, count: firework.particles.count)
        particleOpacities = Array(repeating: 1.0, count: firework.particles.count)
        
        // Animate particles outward
        let animationDuration: Double = 2.0
        _ = Timer.scheduledTimer(withTimeInterval: 0.016, repeats: true) { timer in
            let elapsed = Date().timeIntervalSince(timer.fireDate) + 0.016
            let progress = elapsed / animationDuration
            
            if progress >= 1.0 {
                timer.invalidate()
                return
            }
            
            // Update particle positions
            for i in particles.indices {
                let particle = particles[i]
                let newX = particlePositions[i].x + particle.velocity.dx * 0.016
                let newY = particlePositions[i].y + particle.velocity.dy * 0.016
                
                particlePositions[i] = CGPoint(x: newX, y: newY)
                
                // Fade out
                if progress > 0.5 {
                    particleOpacities[i] = 1.0 - ((progress - 0.5) / 0.5)
                }
            }
        }
    }
}

struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

struct Star: Shape {
    let points: Int
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let innerRadius = radius * 0.4
        
        var path = Path()
        let angle = Double.pi * 2 / Double(points * 2)
        
        for i in 0..<points * 2 {
            let currentRadius = i % 2 == 0 ? radius : innerRadius
            let x = center.x + cos(angle * Double(i)) * currentRadius
            let y = center.y + sin(angle * Double(i)) * currentRadius
            
            if i == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        path.closeSubpath()
        return path
    }
}

struct Diamond: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
        path.closeSubpath()
        return path
    }
} 
