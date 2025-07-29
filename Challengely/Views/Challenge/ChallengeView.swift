//
//  ChallengeView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

/// Main challenge interface where users view, accept, and complete daily challenges
struct ChallengeView: View {
    @EnvironmentObject var dataManager: DataManager
    
    // MARK: - Challenge State
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
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("AppPrimaryColor").opacity(0.08),
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
                            
                            // Action buttons or completion view
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
                
                // Confetti celebration overlay
                if showConfetti {
                    ConfettiView()
                        .allowsHitTesting(false)
                }
            }
            .navigationTitle(Constants.Navigation.challenge)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Constants.Button.refresh) {
                        refreshChallenge()
                    }
                    .disabled(isChallengeAccepted && !isChallengeCompleted)
                    .foregroundColor(Color("AppPrimaryColor"))
                }
            }
        }
        .sheet(isPresented: $showShareSheet) {
            ShareSheetView(challenge: dataManager.currentChallenge, streak: dataManager.userProfile.currentStreak)
        }
        .onAppear {
            // Animate cards on view appearance
            withAnimation(.easeOut(duration: 0.6).delay(0.2)) {
                animateCards = true
            }
            
            // Restore challenge state if already completed
            if let challenge = dataManager.currentChallenge, challenge.isCompleted {
                isChallengeRevealed = true
                isChallengeAccepted = true
                isChallengeCompleted = true
            }
        }
    }
    
    // MARK: - Challenge Actions
    
    /// Reveals the challenge details to the user
    private func revealChallenge() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
            isChallengeRevealed = true
        }
        HapticManager.shared.impact(style: .medium)
    }
    
    /// Accepts the challenge and starts the timer
    private func acceptChallenge() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isChallengeAccepted = true
        }
        HapticManager.shared.impact(style: .heavy)
        
        // Start countdown timer
        if let challenge = dataManager.currentChallenge {
            timeRemaining = challenge.estimatedTime * 60 // Convert to seconds
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                if timeRemaining > 0 {
                    timeRemaining -= 1
                }
            }
        }
    }
    
    /// Completes the challenge and shows celebration
    private func completeChallenge() {
        withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
            isChallengeCompleted = true
        }
        
        timer?.invalidate()
        timer = nil
        
        dataManager.completeChallenge()
        
        // Show confetti celebration
        showConfetti = true
        HapticManager.shared.notification(type: .success)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation(.easeOut(duration: 0.5)) {
                showConfetti = false
            }
        }
    }
    
    /// Refreshes the challenge and resets all state
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
 
