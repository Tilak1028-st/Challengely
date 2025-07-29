import SwiftUI

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var isAnimating = false
    
    let colors: [Color] = [ .primary, .accentColor, .success, .confettiYellow, .challengeRed, .primaryDark, .userBubble]
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Circle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    .position(particle.position)
                    .opacity(particle.opacity)
            }
        }
        .onAppear {
            createParticles()
            startAnimation()
        }
    }
    
    private func createParticles() {
        particles = (0..<50).map { _ in
            ConfettiParticle(
                color: colors.randomElement() ?? .red,
                size: CGFloat.random(in: 4...12),
                position: CGPoint(
                    x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                    y: UIScreen.main.bounds.height + 50
                ),
                opacity: 1.0
            )
        }
    }
    
    private func startAnimation() {
        isAnimating = true
        
        withAnimation(.easeOut(duration: 3.0)) {
            for i in particles.indices {
                particles[i].position.y = -50
                particles[i].position.x += CGFloat.random(in: -100...100)
                particles[i].opacity = 0
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            isAnimating = false
        }
    }
}

struct ConfettiParticle: Identifiable {
    let id = UUID()
    var color: Color
    var size: CGFloat
    var position: CGPoint
    var opacity: Double
} 
