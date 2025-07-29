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
