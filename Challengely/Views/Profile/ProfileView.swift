import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEditProfile = false
    @State private var showingProgressInsights = false
    @State private var showingPreferences = false
    @State private var showingHelpSupport = false
    @State private var animateStats = false
    @State private var animateHeader = false
    @State private var animateCards = false
    @State private var showPulse = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced gradient background with animated elements
                ZStack {
                    // Base gradient
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color("AppPrimaryColor").opacity(0.08),
                            Color("Accent").opacity(0.06),
                            Color("PrimaryDark").opacity(0.04),
                            Color("Background")
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    
                    // Floating particles for engagement
                    ForEach(0..<6) { index in
                        Circle()
                            .fill(Color("AppPrimaryColor").opacity(0.06))
                            .frame(width: CGFloat.random(in: 8...20), height: CGFloat.random(in: 8...20))
                            .position(
                                x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                                y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                            )
                            .scaleEffect(showPulse ? 1.2 : 0.8)
                            .opacity(showPulse ? 0.4 : 0.2)
                            .animation(
                                .easeInOut(duration: 3.0 + Double(index))
                                .repeatForever(autoreverses: true)
                                .delay(Double(index) * 0.5),
                                value: showPulse
                            )
                    }
                }
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 28) {
                        // Enhanced Profile Header with animations
                        ProfileHeaderView()
                            .scaleEffect(animateHeader ? 1.0 : 0.9)
                            .opacity(animateHeader ? 1.0 : 0.0)
                            .offset(y: animateHeader ? 0 : 30)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1), value: animateHeader)
                        
                        // Enhanced Stats Cards with staggered animations
                        StatsGridView()
                            .scaleEffect(animateCards ? 1.0 : 0.95)
                            .opacity(animateCards ? 1.0 : 0.0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.3), value: animateCards)
                        
                        // Achievements with enhanced styling
                        AchievementsView()
                            .scaleEffect(animateCards ? 1.0 : 0.95)
                            .opacity(animateCards ? 1.0 : 0.0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.5), value: animateCards)
                        
                        // Recent Activity with enhanced styling
                        RecentActivityView()
                            .scaleEffect(animateCards ? 1.0 : 0.95)
                            .opacity(animateCards ? 1.0 : 0.0)
                            .offset(y: animateCards ? 0 : 20)
                            .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.7), value: animateCards)
                        
                        // Settings Section with enhanced styling
                        SettingsSectionView(
                            showingProgressInsights: $showingProgressInsights,
                            showingPreferences: $showingPreferences,
                            showingHelpSupport: $showingHelpSupport
                        )
                        .scaleEffect(animateCards ? 1.0 : 0.95)
                        .opacity(animateCards ? 1.0 : 0.0)
                        .offset(y: animateCards ? 0 : 20)
                        .animation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.9), value: animateCards)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { 
                        HapticManager.shared.impact(style: .light)
                        showingEditProfile = true 
                    }) {
                        ZStack {
                            Circle()
                                .fill(Color("AppPrimaryColor").opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundColor(Color("AppPrimaryColor"))
                        }
                    }
                    .scaleEffect(animateHeader ? 1.0 : 0.8)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.4), value: animateHeader)
                }
            }
        }
        .sheet(isPresented: $showingEditProfile) {
            EditProfileView()
        }
        .sheet(isPresented: $showingProgressInsights) {
            ProgressInsightsView()
        }
        .sheet(isPresented: $showingPreferences) {
            PreferencesView()
        }
        .sheet(isPresented: $showingHelpSupport) {
            HelpSupportView()
        }
        .onAppear {
            startAnimations()
        }
    }
    
    private func startAnimations() {
        // Start floating particles
        showPulse = true
        
        // Initial haptic feedback
        HapticManager.shared.impact(style: .light)
        
        // Animate header first
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.1)) {
            animateHeader = true
        }
        
        // Animate cards with staggered timing
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                animateCards = true
            }
        }
        
        // Animate stats
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut(duration: 0.8)) {
                animateStats = true
            }
        }
    }
}


#Preview {
    ProfileView()
        .environmentObject(DataManager())
} 
