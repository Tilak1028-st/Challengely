//
//  AchievementCard.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

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
