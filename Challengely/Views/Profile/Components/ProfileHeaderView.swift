//
//  ProfileHeaderView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

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
