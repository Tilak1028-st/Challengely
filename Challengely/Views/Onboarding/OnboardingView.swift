import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var currentStep = 0
    @State private var selectedInterests: Set<UserProfile.Interest> = []
    @State private var difficultyPreference: UserProfile.DifficultyLevel = .medium
    @State private var showMotivationalText = false
    @State private var animateProgress = false
    @Namespace private var animation
    
    private let totalSteps = 3
    
    var body: some View {
        ZStack {
            // Enhanced gradient background
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("PrimaryColor").opacity(0.1),
                    Color("Accent").opacity(0.1),
                    Color("PrimaryDark").opacity(0.05)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 32) {
                // Skip button
                HStack {
                    Spacer()
                    Button("Skip") {
                        completeOnboarding()
                    }
                    .font(.subheadline)
                    .foregroundColor(.subtext)
                    .underline()
                    .opacity(showMotivationalText ? 1 : 0)
                    .animation(.easeInOut(duration: 0.5).delay(1.0), value: showMotivationalText)
                }
                .padding(.horizontal, 40)
                .padding(.top, 30)
                
                // Enhanced progress indicator
                ProgressView(value: animateProgress ? Double(currentStep + 1) : 0, total: Double(totalSteps))
                    .progressViewStyle(EnhancedProgressViewStyle())
                    .padding(.horizontal, 40)
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1.0)) {
                            animateProgress = true
                        }
                    }
                
                // Content with smooth transitions
                ZStack {
                    if currentStep == 0 {
                        WelcomeStepView()
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    } else if currentStep == 1 {
                        InterestsStepView(selectedInterests: $selectedInterests, namespace: animation)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    } else if currentStep == 2 {
                        DifficultyStepView(difficultyPreference: $difficultyPreference, namespace: animation)
                            .transition(.asymmetric(
                                insertion: .move(edge: .trailing).combined(with: .opacity),
                                removal: .move(edge: .leading).combined(with: .opacity)
                            ))
                    }
                }
                .animation(.easeInOut(duration: 0.5), value: currentStep)
                
                Spacer()
                
                // Motivational text
                if showMotivationalText {
                    Text(motivationalText)
                        .font(.caption)
                        .foregroundColor(.subtext)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .lineLimit(2)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
                
                // Enhanced navigation buttons
                HStack {
                    if currentStep > 0 {
                        Button("Back") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                                showMotivationalText = false
                            }
                            HapticManager.shared.selection()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showMotivationalText = true
                                }
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    
                    Spacer()
                    
                    Button(currentStep == totalSteps - 1 ? "Get Started ✨" : "Next") {
                        if currentStep == totalSteps - 1 {
                            completeOnboarding()
                        } else {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
                                showMotivationalText = false
                            }
                            HapticManager.shared.selection()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showMotivationalText = true
                                }
                            }
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(currentStep == 1 && selectedInterests.isEmpty)
                }
                .padding(.horizontal, 40)
                .padding(.bottom, 30)
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                withAnimation(.easeInOut(duration: 0.5)) {
                    showMotivationalText = true
                }
            }
        }
    }
    
    private var motivationalText: String {
        switch currentStep {
        case 0:
            return "You're about to embark on an amazing journey of growth! 🌱"
        case 1:
            return "Great choices! These will shape your personalized experience. 🎯"
        case 2:
            return "You're 1 step closer to your best self. Let's do this! ✨"
        default:
            return ""
        }
    }
    
    private func completeOnboarding() {
        dataManager.userProfile.interests = Array(selectedInterests)
        dataManager.userProfile.difficultyPreference = difficultyPreference
        dataManager.userProfile.hasCompletedOnboarding = true
        dataManager.saveUserProfile()
        
        HapticManager.shared.notification(type: .success)
    }
}



// MARK: - Enhanced Progress View Style
struct EnhancedProgressViewStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.primary.opacity(0.2))
                    .frame(height: 8)
                
                RoundedRectangle(cornerRadius: 8)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.primary, Color.accentColor]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: geometry.size.width * CGFloat(configuration.fractionCompleted ?? 0))
                    .frame(height: 8)
                    .animation(.easeInOut(duration: 0.5), value: configuration.fractionCompleted)
            }
        }
        .frame(height: 8)
        .shadow(color: Color.primary.opacity(0.3), radius: 4, x: 0, y: 2)
    }
}

// MARK: - Welcome Step View
struct WelcomeStepView: View {
    @State private var animateIcon = false
    @State private var showQuote = false
    
    private let quotes = [
        "The only way to do great work is to love what you do. - Steve Jobs",
        "Growth is the only evidence of life. - John Henry Newman",
        "Every day is a new beginning. Take a deep breath and start again. - Anonymous"
    ]
    
    var body: some View {
        VStack(spacing: 30) {
            // Animated icon
            Image(systemName: "star.circle.fill")
                .font(.system(size: 60, weight: .medium))
                .foregroundColor(.primary)
                .scaleEffect(animateIcon ? 1.1 : 1.0)
                .rotationEffect(.degrees(animateIcon ? 5 : 0))
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateIcon)
                .onAppear {
                    animateIcon = true
                }
            
            VStack(spacing: 16) {
                Text("Welcome to Challengely ✨")
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                Text("Your daily companion for personal growth and meaningful challenges")
                    .font(.body)
                    .foregroundColor(.subtext)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                // Motivational quote
                if showQuote {
                    Text(quotes.randomElement() ?? quotes[0])
                        .font(.caption)
                        .foregroundColor(.subtext)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 10)
                        .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
        }
        .padding(.top, 50)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut(duration: 0.8)) {
                    showQuote = true
                }
            }
        }
    }
}

// MARK: - Interests Step View
struct InterestsStepView: View {
    @Binding var selectedInterests: Set<UserProfile.Interest>
    let namespace: Namespace.ID
    
    var body: some View {
            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Text("What excites you? 🎯")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                
                Text("Tap what excites you to get personalized challenges")
                    .font(.caption)
                    .foregroundColor(.subtext)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .lineLimit(2)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                ForEach(Array(UserProfile.Interest.allCases.enumerated()), id: \.element) { index, interest in
                    InterestCard(
                        interest: interest,
                        isSelected: selectedInterests.contains(interest),
                        namespace: namespace
                    ) {
                        if selectedInterests.contains(interest) {
                            selectedInterests.remove(interest)
                        } else {
                            selectedInterests.insert(interest)
                        }
                        HapticManager.shared.impact(style: .light)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: selectedInterests.contains(interest))
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.top, 30)
    }
}

// MARK: - Enhanced Interest Card
struct InterestCard: View {
    let interest: UserProfile.Interest
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    @State private var isPressed = false
    
    private var interestColor: Color {
        switch interest {
        case .fitness: return Color("ChallengeRed")
        case .creativity: return Color("PrimaryDark")
        case .mindfulness: return Color("PrimaryColor")
        case .learning: return Color("Success")
        case .social: return Color("Accent")
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: interest.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : interestColor)
                
                Text(interest.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : Color("TextLabel"))
            }
            .frame(height: 105)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? interestColor : interestColor.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(interestColor, lineWidth: isSelected ? 0 : 2)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : (isSelected ? 1.02 : 1.0))
            .shadow(color: isSelected ? interestColor.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            .zIndex(isSelected ? 1 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}

// MARK: - Difficulty Step View
struct DifficultyStepView: View {
    @Binding var difficultyPreference: UserProfile.DifficultyLevel
    let namespace: Namespace.ID
    
    var body: some View {
                    VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Text("Choose your pace 🚀")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                
                Text("We'll tailor challenges to match your comfort zone")
                    .font(.caption)
                    .foregroundColor(.subtext)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .lineLimit(2)
            }
            
            VStack(spacing: 16) {
                ForEach(Array(UserProfile.DifficultyLevel.allCases.enumerated()), id: \.element) { index, difficulty in
                    DifficultyCard(
                        difficulty: difficulty,
                        isSelected: difficultyPreference == difficulty,
                        namespace: namespace
                    ) {
                        difficultyPreference = difficulty
                        HapticManager.shared.impact(style: .medium)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: difficultyPreference == difficulty)
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.top, 30)
    }
}

// MARK: - Enhanced Difficulty Card
struct DifficultyCard: View {
    let difficulty: UserProfile.DifficultyLevel
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    @State private var isPressed = false
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return Color("Success")
        case .medium: return Color("Accent")
        case .hard: return Color("ChallengeRed")
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(difficulty.rawValue)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(difficultyDescription)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .subtext)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : difficultyColor)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? difficultyColor : difficultyColor.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(difficultyColor, lineWidth: isSelected ? 0 : 2)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : (isSelected ? 1.01 : 1.0))
            .shadow(color: isSelected ? difficultyColor.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            .zIndex(isSelected ? 1 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private var difficultyDescription: String {
        switch difficulty {
        case .easy:
            return "Gentle challenges to build confidence 🌱"
        case .medium:
            return "Balanced challenges for steady growth ⚖️"
        case .hard:
            return "Ambitious challenges to push limits 🔥"
        }
    }
}

// MARK: - Enhanced Button Styles
struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("PrimaryColor"), Color("Accent")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            )
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
                            .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 8, x: 0, y: 4)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .fontWeight(.semibold)
            .foregroundColor(.primary)
            .frame(height: 48)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.primary, lineWidth: 2)
                    .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            )
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    OnboardingView()
} 
 