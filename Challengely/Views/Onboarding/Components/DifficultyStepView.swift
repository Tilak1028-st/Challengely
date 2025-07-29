//
//  DifficultyStepView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct DifficultyStepView: View {
    @Binding var difficultyPreference: UserProfile.DifficultyLevel
    let namespace: Namespace.ID
    
    var body: some View {
                    VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Text(Constants.Onboarding.difficultyTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                
                Text(Constants.Onboarding.difficultySubtitle)
                    .font(.caption)
                    .foregroundColor(Color("Subtext"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .lineLimit(2)
            }
            
            VStack(spacing: 16) {
                ForEach(Array(UserProfile.DifficultyLevel.allCases.enumerated()), id: \.element) { index, difficulty in
                    DifficultyCard(
                        difficulty: difficulty,
                        isSelected: difficultyPreference == difficulty,
                        namespace: namespace
                    ) {
                        difficultyPreference = difficulty
                        HapticManager.shared.impact(style: .medium)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: difficultyPreference == difficulty)
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.top, 30)
    }
}
