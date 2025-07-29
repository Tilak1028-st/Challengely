//
//  Achievement.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

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
                color: AppColor.challengeRed,
                isEarned: true
            ))
        }
        
        if dataManager.userProfile.longestStreak >= 30 {
            earned.append(Achievement(
                title: "Monthly Master",
                description: "Achieved a 30-day streak",
                icon: "calendar.circle.fill",
                color: AppColor.accent,
                isEarned: true
            ))
        }
        
        // Completion achievements
        if dataManager.userProfile.totalChallengesCompleted >= 10 {
            earned.append(Achievement(
                title: "Dedicated Learner",
                description: "Completed 10 challenges",
                icon: "graduationcap.fill",
                color: AppColor.success,
                isEarned: true
            ))
        }
        
        if dataManager.userProfile.totalChallengesCompleted >= 50 {
            earned.append(Achievement(
                title: "Challenge Champion",
                description: "Completed 50 challenges",
                icon: "crown.fill",
                color: AppColor.appPrimary,
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
                    .foregroundColor(AppColor.textLabel)
                
                Spacer()
                
                Text("\(achievements.count) earned")
                    .font(.caption)
                    .foregroundColor(AppColor.subtext)
            }
            
            if achievements.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "star.circle")
                        .font(.system(size: 40))
                        .foregroundColor(AppColor.subtext.opacity(0.5))
                    
                    Text("No achievements yet")
                        .font(.headline)
                        .foregroundColor(AppColor.subtext)
                    
                    Text("Complete challenges to earn achievements!")
                        .font(.caption)
                        .foregroundColor(AppColor.subtext.opacity(0.7))
                        .multilineTextAlignment(.center)
                }
                .padding(30)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(AppColor.card.opacity(0.5))
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
