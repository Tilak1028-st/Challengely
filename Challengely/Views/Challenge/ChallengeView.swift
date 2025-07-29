import SwiftUI

struct ChallengeView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var isChallengeRevealed = false
    @State private var isChallengeAccepted = false
    @State private var isChallengeCompleted = false
    @State private var showConfetti = false
    @State private var showShareSheet = false
    @State private var timeRemaining: Int = 0
    @State private var timer: Timer?
    @State private var animateCards = false
    
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
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header with streak info
                        HeaderView(dataManager: dataManager)
                            .transition(.scale.combined(with: .opacity))
                        
                        if let challenge = dataManager.currentChallenge {
                            // Challenge card
                            ChallengeCardView(
                                challenge: challenge,
                                isRevealed: isChallengeRevealed,
                                isAccepted: isChallengeAccepted,
                                isCompleted: isChallengeCompleted,
                                timeRemaining: timeRemaining
                            )
                            .transition(.scale.combined(with: .opacity))
                            
                            // Action buttons
                            if !isChallengeCompleted {
                                ActionButtonsView(
                                    isRevealed: isChallengeRevealed,
                                    isAccepted: isChallengeAccepted,
                                    onReveal: revealChallenge,
                                    onAccept: acceptChallenge,
                                    onComplete: completeChallenge
                                )
                                .transition(.scale.combined(with: .opacity))
                            } else {
                                CompletionView(
                                    challenge: challenge,
                                    onShare: { showShareSheet = true }
                                )
                                .transition(.scale.combined(with: .opacity))
                            }
                        } else {
                            // Loading state
                            LoadingView()
                                .transition(.scale.combined(with: .opacity))
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                // Confetti overlay
                if showConfetti {
                    ConfettiView()
                        .allowsHitTesting(false)
                }
            }
            .navigationTitle("Today's Challenge")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Refresh") {
                        refreshChallenge()
                    }
                    .disabled(isChallengeAccepted && !isChallengeCompleted)
                    .foregroundColor(Color("PrimaryColor"))
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheetView(challenge: dataManager.currentChallenge, streak: dataManager.userProfile.currentStreak)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateCards = true
            }
            
            if let challenge = dataManager.currentChallenge, challenge.isCompleted {
                isChallengeRevealed = true
                isChallengeAccepted = true
                isChallengeCompleted = true
            }
        }
    }
    
    private func revealChallenge() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isChallengeRevealed = true
        }
        HapticManager.shared.impact(style: .medium)
    }
    
    private func acceptChallenge() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isChallengeAccepted = true
        }
        HapticManager.shared.impact(style: .heavy)
        
        // Start timer
        if let challenge = dataManager.currentChallenge {
            timeRemaining = challenge.estimatedTime * 60 // Convert to seconds
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        }
    }
    
    private func completeChallenge() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
            isChallengeCompleted = true
        }
        
        timer?.invalidate()
        timer = nil
        
        dataManager.completeChallenge()
        
        // Show confetti
        showConfetti = true
        HapticManager.shared.notification(type: .success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeOut(duration: 0.5)) {
                showConfetti = false
            }
        }
    }
    
    private func refreshChallenge() {
        dataManager.generateNewChallenge()
        isChallengeRevealed = false
        isChallengeAccepted = false
        isChallengeCompleted = false
        timeRemaining = 0
        timer?.invalidate()
        timer = nil
        HapticManager.shared.impact(style: .light)
    }
}
 
#Preview(body: {
    ChallengeView()
})
 
