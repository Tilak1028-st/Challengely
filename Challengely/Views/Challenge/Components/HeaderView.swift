//
//  HeaderView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI


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
                        .foregroundColor(AppColor.subtext)
                    
                    HStack(alignment: .bottom, spacing: 4) {
                        Text("\(dataManager.userProfile.currentStreak)")
                            .font(.system(size: 28, weight: .bold, design: .rounded))
                            .foregroundColor(AppColor.appPrimary)
                        
                        Text(Constants.Time.days)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(AppColor.subtext)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 5) {
                    Text("✨ Total Completed")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(AppColor.subtext)
                    
                    Text("\(dataManager.userProfile.totalChallengesCompleted)")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(AppColor.appPrimary)
                }
            }
            
            // Enhanced streak progress bar
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("Progress to longest streak")
                        .font(.caption)
                        .foregroundColor(AppColor.subtext)
                    
                    Spacer()
                    
                    Text("\(dataManager.userProfile.currentStreak)/\(max(dataManager.userProfile.longestStreak, 1))")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(AppColor.appPrimary)
                }
                
                ProgressView(value: Double(dataManager.userProfile.currentStreak), total: Double(max(dataManager.userProfile.longestStreak, 1)))
                    .progressViewStyle(EnhancedProgressViewStyle())
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.card)
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
