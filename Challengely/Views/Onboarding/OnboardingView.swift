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
                    AppColor.appPrimary.opacity(0.1),
                    AppColor.accent.opacity(0.1),
                    AppColor.primaryDark.opacity(0.05)
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
                    .foregroundColor(AppColor.subtext)
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
                        .foregroundColor(AppColor.subtext)
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

#Preview {
    OnboardingView()
} 
 
