//
//  InterestsStepView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct InterestsStepView: View {
    @Binding var selectedInterests: Set<UserProfile.Interest>
    let namespace: Namespace.ID
    
    var body: some View {
            VStack(spacing: 28) {
                VStack(spacing: 12) {
                    Text(Constants.Onboarding.interestsTitle)
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                
                Text(Constants.Onboarding.interestsSubtitle)
                    .font(.caption)
                    .foregroundColor(Color("Subtext"))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .lineLimit(2)
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 20) {
                ForEach(Array(UserProfile.Interest.allCases.enumerated()), id: \.element) { index, interest in
                    InterestCard(
                        interest: interest,
                        isSelected: selectedInterests.contains(interest),
                        namespace: namespace
                    ) {
                        if selectedInterests.contains(interest) {
                            selectedInterests.remove(interest)
                        } else {
                            selectedInterests.insert(interest)
                        }
                        HapticManager.shared.impact(style: .light)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(Double(index) * 0.1), value: selectedInterests.contains(interest))
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.top, 30)
    }
}
