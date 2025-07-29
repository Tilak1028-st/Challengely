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
                        AppColor.appPrimary.opacity(0.08),
                        AppColor.accent.opacity(0.05),
                        AppColor.primaryDark.opacity(0.03)
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
                                .foregroundColor(AppColor.textLabel)
                            
                            Text("Celebrate your success and inspire others to take on their own challenges")
                                .font(.body)
                                .foregroundColor(AppColor.subtext)
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
                    Button(Constants.Button.done) {
                        dismiss()
                    }
                    .foregroundColor(AppColor.appPrimary)
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
            Current streak: \(streak) \(Constants.Time.days)
            
            Join me on \(Constants.App.name) for daily personal growth challenges!
            """
            
            UIPasteboard.general.string = shareText
            HapticManager.shared.notification(type: .success)
        }
    }
}
