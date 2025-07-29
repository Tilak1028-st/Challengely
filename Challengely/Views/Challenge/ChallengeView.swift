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

// MARK: - Header View
struct HeaderView: View {
    @ObservedObject var dataManager: DataManager
    @State private var animateProgress = false
    
    var body: some View {
        VStack(spacing: 15) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("🔥 Current Streak")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color("Subtext"))
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(dataManager.userProfile.currentStreak)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(Color("PrimaryColor"))
                        
                        Text("days")
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(Color("Subtext"))
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("✨ Total Completed")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color("Subtext"))
                    
                    Text("\(dataManager.userProfile.totalChallengesCompleted)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("PrimaryColor"))
                }
            }
            
            // Enhanced streak progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress to longest streak")
                        .font(.caption)
                        .foregroundColor(Color("Subtext"))
                    
                    Spacer()
                    
                    Text("\(dataManager.userProfile.currentStreak)/\(max(dataManager.userProfile.longestStreak, 1))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color("PrimaryColor"))
                }
                
                ProgressView(value: Double(dataManager.userProfile.currentStreak), total: Double(max(dataManager.userProfile.longestStreak, 1)))
                    .progressViewStyle(EnhancedProgressViewStyle())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("Card"))
                .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
        )
        .scaleEffect(animateProgress ? 1.02 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animateProgress = true
            }
        }
    }
}

// MARK: - Challenge Card View
struct ChallengeCardView: View {
    let challenge: Challenge
    let isRevealed: Bool
    let isAccepted: Bool
    let isCompleted: Bool
    let timeRemaining: Int
    
    @State private var animateCard = false
    
    private var categoryColor: Color {
        switch challenge.category {
        case .fitness: return Color("ChallengeRed")
        case .creativity: return Color("PrimaryDark")
        case .mindfulness: return Color("PrimaryColor")
        case .learning: return Color("Success")
        case .social: return Color("Accent")
        }
    }
    
    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .easy: return Color("Success")
        case .medium: return Color("Accent")
        case .hard: return Color("ChallengeRed")
        }
    }
    
    var body: some View {
        VStack(spacing: 25) {
            // Challenge icon and category
            HStack {
                Image(systemName: challenge.category.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(categoryColor)
                    .scaleEffect(animateCard ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateCard)
                
                Spacer()
                
                Text(challenge.category.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(categoryColor.opacity(0.15))
                    )
                    .foregroundColor(categoryColor)
            }
            
            // Challenge title or placeholder
            if isRevealed {
                Text(challenge.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("TextLabel"))
                    .transition(.opacity.combined(with: .scale))
            } else {
                VStack(spacing: 8) {
                    Image(systemName: "eye.slash.fill")
                        .font(.title2)
                        .foregroundColor(Color("Subtext"))
                        .scaleEffect(animateCard ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateCard)
                    
                    Text("Challenge Hidden")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Subtext"))
                    
                    Text("Tap 'Reveal Challenge' to see today's task")
                        .font(.caption)
                        .foregroundColor(Color("Subtext"))
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
            }
            
            // Challenge description
            if isRevealed {
                Text(challenge.description)
                    .font(.body)
                    .foregroundColor(Color("Subtext"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
                    .transition(.opacity.combined(with: .scale))
            }
            
            // Challenge details
            if isRevealed {
                HStack(spacing: 30) {
                    DetailItem(
                        icon: "clock.fill",
                        title: "Time",
                        value: "\(challenge.estimatedTime) min",
                        color: Color("PrimaryColor")
                    )
                    
                    DetailItem(
                        icon: "gauge",
                        title: "Difficulty",
                        value: challenge.difficulty.rawValue,
                        color: difficultyColor
                    )
                }
                .transition(.opacity.combined(with: .scale))
            }
            
            // Timer (if challenge is accepted)
            if isAccepted && !isCompleted {
                TimerView(timeRemaining: timeRemaining)
                    .transition(.opacity.combined(with: .scale))
            }
            
            // Completion status
            if isCompleted {
                HStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(Color("Success"))
                    
                    Text("Challenge Completed! 🎉")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("Success"))
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("Card"))
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
        )
        .scaleEffect(isRevealed ? 1 : 0.95)
        .opacity(isRevealed ? 1 : 0.8)
        .onAppear {
            animateCard = true
        }
    }
}

// MARK: - Detail Item
struct DetailItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color("Subtext"))
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color("TextLabel"))
        }
    }
}

// MARK: - Timer View
struct TimerView: View {
    let timeRemaining: Int
    @State private var pulse = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("⏱️ Time Remaining")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color("Subtext"))
            
            Text(timeString)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(Color("PrimaryColor"))
                .scaleEffect(pulse ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulse)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("PrimaryColor").opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("PrimaryColor").opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            pulse = true
        }
    }
    
    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

// MARK: - Action Buttons View
struct ActionButtonsView: View {
    let isRevealed: Bool
    let isAccepted: Bool
    let onReveal: () -> Void
    let onAccept: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            if !isRevealed {
                Button(action: onReveal) {
                    HStack {
                        Image(systemName: "eye.fill")
                            .font(.title3)
                        Text("Reveal Challenge")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("PrimaryColor"))
                    )
                    .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            } else if !isAccepted {
                Button(action: onAccept) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                        Text("Accept Challenge")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Accent"))
                    )
                    .shadow(color: Color("Accent").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: onComplete) {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .font(.title3)
                        Text("Complete Challenge")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Success"))
                    )
                    .shadow(color: Color("Success").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Completion View
struct CompletionView: View {
    let challenge: Challenge
    let onShare: () -> Void
    @State private var animateCompletion = false
    
    var body: some View {
        VStack(spacing: 25) {
            // Celebration icon
            Image(systemName: "party.popper.fill")
                .font(.system(size: 40))
                .foregroundColor(Color("Success"))
                .scaleEffect(animateCompletion ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animateCompletion)
            
            VStack(spacing: 12) {
                Text("🎉 Congratulations! 🎉")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Success"))
                
                Text("You've completed today's challenge!")
                    .font(.body)
                    .foregroundColor(Color("Subtext"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Button(action: onShare) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                    Text("Share Achievement")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("PrimaryColor"))
                )
                .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("Success").opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("Success").opacity(0.2), lineWidth: 2)
                )
        )
        .onAppear {
            animateCompletion = true
        }
    }
}

// MARK: - Loading View
struct LoadingView: View {
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color("PrimaryColor"))
            
            Text("Loading your challenge...")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color("Subtext"))
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Card"))
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
        )
        .scaleEffect(animate ? 1.02 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}

 
#Preview(body: {
    ChallengeView()
})
 