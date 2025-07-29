import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var showText = false
    @State private var textScale: CGFloat = 0.5
    
    let colors: [Color] = [
        AppColor.appPrimary,
        AppColor.accent,
        AppColor.success,
        AppColor.confettiYellow
    ]
    
    var body: some View {
        ZStack {
            // Simple celebration background
            RadialGradient(
                gradient: Gradient(colors: [
                    AppColor.appPrimary.opacity(0.2),
                    Color.clear
                ]),
                center: .center,
                startRadius: 0,
                endRadius: 150
            )
            .scaleEffect(showText ? 1.0 : 0.0)
            .animation(.easeOut(duration: 0.6), value: showText)
            
            // Simple confetti particles
            ForEach(particles) { particle in
                ConfettiParticleView(particle: particle)
            }
            
            // Celebration text
            if showText {
                Text("🎉 Great Job!")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .scaleEffect(textScale)
                    .opacity(showText ? 1.0 : 0.0)
                    .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 1)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7), value: textScale)
            }
        }
        .onAppear {
            createSimpleCelebration()
            startSimpleAnimation()
        }
    }
    
    private func createSimpleCelebration() {
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let centerX = screenWidth / 2
        let centerY = screenHeight / 2
        
        // Create simple confetti particles (reduced from 100 to 20)
        particles = (0..<20).map { index in
            let angle = Double(index) * (2 * .pi / 20)
            let radius = CGFloat.random(in: 40...100)
            let startX = centerX + cos(angle) * radius
            let startY = centerY + sin(angle) * radius
            
            return ConfettiParticle(
                color: colors.randomElement() ?? AppColor.appPrimary,
                size: CGFloat.random(in: 6...12),
                position: CGPoint(x: startX, y: startY),
                opacity: 1.0,
                rotation: Double.random(in: 0...360),
                shape: .circle,
                velocity: CGVector(
                    dx: CGFloat.random(in: -150...150),
                    dy: CGFloat.random(in: -300...(-100))
                ),
                gravity: 500,
                wind: 0
            )
        }
    }
    
    private func startSimpleAnimation() {
        // Show celebration text
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                showText = true
                textScale = 1.0
            }
        }
        
        // Simple particle animation (reduced duration from 5s to 3s)
        let animationDuration: Double = 3.0
        _ = Timer.scheduledTimer(withTimeInterval: 0.032, repeats: true) { timer in
            let elapsed = Date().timeIntervalSince(timer.fireDate) + 0.032
            let progress = elapsed / animationDuration
            
            if progress >= 1.0 {
                timer.invalidate()
                return
            }
            
            // Update particle physics (simplified)
            for i in particles.indices {
                let particle = particles[i]
                
                // Apply simple physics
                let newX = particle.position.x + particle.velocity.dx * 0.032
                let newY = particle.position.y + particle.velocity.dy * 0.032
                
                // Apply gravity
                particles[i].velocity.dy += particle.gravity * 0.032
                
                // Update position
                particles[i].position = CGPoint(x: newX, y: newY)
                
                // Update rotation
                particles[i].rotation += 2.0
                
                // Fade out near the end
                if progress > 0.7 {
                    particles[i].opacity = 1.0 - ((progress - 0.7) / 0.3)
                }
            }
        }
        
        // Single haptic feedback
        HapticManager.shared.notification(type: .success)
        
        // Cleanup celebration
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                showText = false
                textScale = 0.5
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

enum ConfettiShape: CaseIterable {
    case circle
}

struct ConfettiParticleView: View {
    let particle: ConfettiParticle
    
    var body: some View {
        Circle()
            .fill(particle.color)
            .frame(width: particle.size, height: particle.size)
            .position(particle.position)
            .opacity(particle.opacity)
            .rotationEffect(.degrees(particle.rotation))
    }
} 
