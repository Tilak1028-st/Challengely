import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEditProfile = false
    @State private var showingProgressInsights = false
    @State private var showingPreferences = false
    @State private var showingHelpSupport = false
    @State private var animateStats = false
    
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
                    VStack(spacing: 24) {
                        // Profile Header
                        ProfileHeaderView()
                        
                        // Stats Cards
                        StatsGridView()
                        
                        // Achievements
                        AchievementsView()
                        
                        // Recent Activity
                        RecentActivityView()
                        
                        // Settings Section
                        SettingsSectionView(
                            showingProgressInsights: $showingProgressInsights,
                            showingPreferences: $showingPreferences,
                            showingHelpSupport: $showingHelpSupport
                        )
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
                    Button(action: { showingEditProfile = true }) {
                        Image(systemName: "pencil.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color("PrimaryColor"))
                    }
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
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateStats = true
            }
        }
    }
}


#Preview {
    ProfileView()
        .environmentObject(DataManager())
} 
