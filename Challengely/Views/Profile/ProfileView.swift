import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var showingEditProfile = false
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
                        SettingsSectionView()
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
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.2)) {
                animateStats = true
            }
        }
    }
}

// MARK: - Profile Header
struct ProfileHeaderView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(spacing: 20) {
            // Avatar
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [Color("PrimaryColor"), Color("Accent")]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                    .shadow(color: Color("PrimaryColor").opacity(0.3), radius: 10, x: 0, y: 5)
                
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
            }
            
            VStack(spacing: 8) {
                Text("Challenge Champion")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextLabel"))
                
                Text("Level \(calculateLevel()) • \(dataManager.userProfile.interests.count) Interests")
                    .font(.subheadline)
                    .foregroundColor(Color("Subtext"))
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color("Card"))
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
        )
    }
    
    private func calculateLevel() -> Int {
        let completed = dataManager.userProfile.totalChallengesCompleted
        return max(1, (completed / 5) + 1)
    }
}

// MARK: - Stats Grid
struct StatsGridView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var animateStats = false
    
    var body: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 16) {
            StatCard(
                title: "Current Streak",
                value: "\(dataManager.userProfile.currentStreak)",
                subtitle: "days",
                icon: "flame.fill",
                color: Color("ChallengeRed"),
                animate: animateStats
            )
            
            StatCard(
                title: "Total Completed",
                value: "\(dataManager.userProfile.totalChallengesCompleted)",
                subtitle: "challenges",
                icon: "checkmark.circle.fill",
                color: Color("Success"),
                animate: animateStats
            )
            
            StatCard(
                title: "Longest Streak",
                value: "\(dataManager.userProfile.longestStreak)",
                subtitle: "days",
                icon: "trophy.fill",
                color: Color("Accent"),
                animate: animateStats
            )
            
            StatCard(
                title: "Success Rate",
                value: "\(calculateSuccessRate())%",
                subtitle: "completion",
                icon: "chart.line.uptrend.xyaxis",
                color: Color("PrimaryColor"),
                animate: animateStats
            )
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 0.8).delay(0.3)) {
                animateStats = true
            }
        }
    }
    
    private func calculateSuccessRate() -> Int {
        let completed = dataManager.userProfile.totalChallengesCompleted
        let total = max(completed, 1) // Avoid division by zero
        return min(100, Int((Double(completed) / Double(total)) * 100))
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    let animate: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .scaleEffect(animate ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animate)
            
            VStack(spacing: 4) {
                Text(value)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextLabel"))
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color("Subtext"))
                    .multilineTextAlignment(.center)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(Color("Subtext").opacity(0.7))
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("Card"))
                .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 4)
        )
    }
}

// MARK: - Achievements
struct AchievementsView: View {
    @EnvironmentObject var dataManager: DataManager
    
    private var achievements: [Achievement] {
        var earned: [Achievement] = []
        
        // Streak achievements
        if dataManager.userProfile.currentStreak >= 7 {
            earned.append(Achievement(
                title: "Week Warrior",
                description: "Maintained a 7-day streak",
                icon: "flame.fill",
                color: Color("ChallengeRed"),
                isEarned: true
            ))
        }
        
        if dataManager.userProfile.longestStreak >= 30 {
            earned.append(Achievement(
                title: "Monthly Master",
                description: "Achieved a 30-day streak",
                icon: "calendar.circle.fill",
                color: Color("Accent"),
                isEarned: true
            ))
        }
        
        // Completion achievements
        if dataManager.userProfile.totalChallengesCompleted >= 10 {
            earned.append(Achievement(
                title: "Dedicated Learner",
                description: "Completed 10 challenges",
                icon: "graduationcap.fill",
                color: Color("Success"),
                isEarned: true
            ))
        }
        
        if dataManager.userProfile.totalChallengesCompleted >= 50 {
            earned.append(Achievement(
                title: "Challenge Champion",
                description: "Completed 50 challenges",
                icon: "crown.fill",
                color: Color("PrimaryColor"),
                isEarned: true
            ))
        }
        
        return earned
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Achievements")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("TextLabel"))
                
                Spacer()
                
                Text("\(achievements.count) earned")
                    .font(.caption)
                    .foregroundColor(Color("Subtext"))
            }
            
            if achievements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star.circle")
                        .font(.system(size: 40))
                        .foregroundColor(Color("Subtext").opacity(0.5))
                    
                    Text("No achievements yet")
                        .font(.headline)
                        .foregroundColor(Color("Subtext"))
                    
                    Text("Complete challenges to earn achievements!")
                        .font(.caption)
                        .foregroundColor(Color("Subtext").opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("Card").opacity(0.5))
                )
            } else {
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach(achievements) { achievement in
                        AchievementCard(achievement: achievement)
                    }
                }
            }
        }
    }
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isEarned: Bool
}

struct AchievementCard: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: achievement.icon)
                .font(.title2)
                .foregroundColor(achievement.color)
            
            VStack(spacing: 4) {
                Text(achievement.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(Color("TextLabel"))
                    .multilineTextAlignment(.center)
                
                Text(achievement.description)
                    .font(.caption2)
                    .foregroundColor(Color("Subtext"))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("Card"))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(achievement.color.opacity(0.3), lineWidth: 1)
                )
        )
    }
}

// MARK: - Recent Activity
struct RecentActivityView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("TextLabel"))
            
            VStack(spacing: 12) {
                ForEach(0..<min(3, dataManager.chatMessages.count), id: \.self) { index in
                    let message = dataManager.chatMessages[dataManager.chatMessages.count - 1 - index]
                    ActivityRow(
                        icon: message.isFromUser ? "person.circle.fill" : "brain.head.profile",
                        title: message.isFromUser ? "You sent a message" : "Assistant responded",
                        subtitle: message.content.prefix(50) + (message.content.count > 50 ? "..." : ""),
                        time: message.timestamp,
                        color: message.isFromUser ? Color("Accent") : Color("PrimaryColor")
                    )
                }
                
                if dataManager.chatMessages.isEmpty {
                    Text("No recent activity")
                        .font(.caption)
                        .foregroundColor(Color("Subtext"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
        }
    }
}

struct ActivityRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let time: Date
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextLabel"))
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(Color("Subtext"))
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(time, style: .time)
                .font(.caption2)
                .foregroundColor(Color("Subtext"))
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("Card"))
        )
    }
}

// MARK: - Settings Section
struct SettingsSectionView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("TextLabel"))
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "bell.fill",
                    title: "Notifications",
                    subtitle: "Daily challenge reminders",
                    color: Color("Accent")
                )
                
                SettingsRow(
                    icon: "chart.bar.fill",
                    title: "Progress Insights",
                    subtitle: "View detailed analytics",
                    color: Color("Success")
                )
                
                SettingsRow(
                    icon: "gear",
                    title: "Preferences",
                    subtitle: "Customize your experience",
                    color: Color("PrimaryColor")
                )
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    subtitle: "Get assistance",
                    color: Color("Subtext")
                )
            }
        }
    }
}

struct SettingsRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(Color("TextLabel"))
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(Color("Subtext"))
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(Color("Subtext"))
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("Card"))
        )
    }
}

// MARK: - Edit Profile View
struct EditProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Edit Profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding()
                
                Spacer()
                
                Text("Profile editing coming soon!")
                    .foregroundColor(Color("Subtext"))
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(DataManager())
} 