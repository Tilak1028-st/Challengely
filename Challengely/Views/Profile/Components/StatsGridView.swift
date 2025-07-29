//
//  StatsGridView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

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
                color: AppColor.challengeRed,
                animate: animateStats
            )
            
            StatCard(
                title: "Total Completed",
                value: "\(dataManager.userProfile.totalChallengesCompleted)",
                subtitle: "challenges",
                icon: "checkmark.circle.fill",
                color: AppColor.success,
                animate: animateStats
            )
            
            StatCard(
                title: "Longest Streak",
                value: "\(dataManager.userProfile.longestStreak)",
                subtitle: "days",
                icon: "trophy.fill",
                color: AppColor.accent,
                animate: animateStats
            )
            
            StatCard(
                title: "Success Rate",
                value: "\(calculateSuccessRate())%",
                subtitle: "completion",
                icon: "chart.line.uptrend.xyaxis",
                color: AppColor.appPrimary,
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
