import SwiftUI

struct ShareSheetView: View {
    let challenge: Challenge?
    let streak: Int
    @Environment(\.dismiss) private var dismiss
    @State private var animateShareCard = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("PrimaryColor").opacity(0.08),
                        Color("Accent").opacity(0.05),
                        Color("PrimaryDark").opacity(0.03)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    if let challenge = challenge {
                                            // Share card preview
                    ShareCardView(challenge: challenge, streak: streak)
                        .frame(maxWidth: 280, maxHeight: 360)
                        .shadow(color: Color.black.opacity(0.15), radius: 20, x: 0, y: 10)
                        .scaleEffect(animateShareCard ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateShareCard)
                    }
                    
                    VStack(spacing: 25) {
                        VStack(spacing: 12) {
                            Text("🎉 Share Your Achievement! 🎉")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("TextLabel"))
                            
                            Text("Celebrate your success and inspire others to take on their own challenges")
                                .font(.body)
                                .foregroundColor(Color("Subtext"))
                                .multilineTextAlignment(.center)
                                .lineSpacing(4)
                                .padding(.horizontal, 20)
                        }
                        
                        // Share buttons
                        VStack(spacing: 16) {
                            ShareButton(
                                title: "Share to Instagram",
                                icon: "camera.fill",
                                color: Color.purple,
                                gradient: [Color.purple, Color.pink]
                            ) {
                                shareToInstagram()
                            }
                            
                            ShareButton(
                                title: "Share to Messages",
                                icon: "message.fill",
                                color: Color.green,
                                gradient: [Color.green, Color.mint]
                            ) {
                                shareToMessages()
                            }
                            
                            ShareButton(
                                title: "Share to WhatsApp",
                                icon: "phone.fill",
                                color: Color.green,
                                gradient: [Color.green, Color.teal]
                            ) {
                                shareToWhatsApp()
                            }
                            
                            ShareButton(
                                title: "Copy to Clipboard",
                                icon: "doc.on.doc.fill",
                                color: Color.blue,
                                gradient: [Color.blue, Color.cyan]
                            ) {
                                copyToClipboard()
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
            }
            .navigationTitle("Share Achievement")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundColor(Color("PrimaryColor"))
                    .fontWeight(.semibold)
                }
            }
        }
        .onAppear {
            animateShareCard = true
        }
    }
    
    private func shareToInstagram() {
        // In a real app, this would integrate with Instagram's sharing API
        HapticManager.shared.impact(style: .medium)
        // For demo purposes, just show success
    }
    
    private func shareToMessages() {
        // In a real app, this would open Messages with pre-filled content
        HapticManager.shared.impact(style: .medium)
        // For demo purposes, just show success
    }
    
    private func shareToWhatsApp() {
        // In a real app, this would open WhatsApp with pre-filled content
        HapticManager.shared.impact(style: .medium)
        // For demo purposes, just show success
    }
    
    private func copyToClipboard() {
        if let challenge = challenge {
            let shareText = """
            🎉 Challenge Completed! 🎉
            
            I just completed: \(challenge.title)
            Current streak: \(streak) days
            
            Join me on Challengely for daily personal growth challenges!
            """
            
            UIPasteboard.general.string = shareText
            HapticManager.shared.notification(type: .success)
        }
    }
}

struct ShareCardView: View {
    let challenge: Challenge
    let streak: Int
    @State private var animateElements = false
    
    var body: some View {
        VStack(spacing: 25) {
                            // Header
                VStack(spacing: 12) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 36))
                        .foregroundColor(Color("ConfettiYellow"))
                        .scaleEffect(animateElements ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateElements)
                    
                    Text("Challenge Completed!")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextLabel"))
                }
            
            // Challenge info
            VStack(spacing: 20) {
                Text(challenge.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("TextLabel"))
                    .lineSpacing(4)
                
                HStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text("\(challenge.estimatedTime)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("PrimaryColor"))
                        
                        Text("minutes")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color("Subtext"))
                    }
                    
                    VStack(spacing: 8) {
                        Text("\(streak)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Accent"))
                        
                        Text("day streak")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color("Subtext"))
                    }
                }
            }
            
            // Footer
            VStack(spacing: 6) {
                Text("Challengely")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Subtext"))
                
                Text("Daily Personal Growth")
                    .font(.caption2)
                    .foregroundColor(Color("Subtext"))
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("PrimaryColor").opacity(0.08),
                    Color("Accent").opacity(0.05),
                    Color("PrimaryDark").opacity(0.03)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("PrimaryColor").opacity(0.2), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            animateElements = true
        }
    }
}

struct ShareButton: View {
    let title: String
    let icon: String
    let color: Color
    let gradient: [Color]
    let action: () -> Void
    @State private var isPressed = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.white)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: gradient),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
            .shadow(color: color.opacity(0.3), radius: 8, x: 0, y: 4)
            .scaleEffect(isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: isPressed)
        }
        .buttonStyle(PlainButtonStyle())
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
} 
 