//
//  ChallengeCardView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct ChallengeCardView: View {
    let challenge: Challenge
    let isRevealed: Bool
    let isAccepted: Bool
    let isCompleted: Bool
    let timeRemaining: Int
    
    @State private var animateCard = false
    
    private var categoryColor: Color {
        switch challenge.category {
        case .fitness: return AppColor.challengeRed
        case .creativity: return AppColor.primaryDark
        case .mindfulness: return AppColor.appPrimary
        case .learning: return AppColor.success
        case .social: return AppColor.accent
        }
    }
    
    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .easy: return AppColor.success
        case .medium: return AppColor.accent
        case .hard: return AppColor.challengeRed
        }
    }
    
    var body: some View {
        VStack(spacing: 25) {
            // Challenge icon and category
            HStack {
                Image(systemName: challenge.category.icon)
                    .font(.system(size: 24, weight: .semibold))
                    .foregroundColor(categoryColor)
                    .scaleEffect(animateCard ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateCard)
                
                Spacer()
                
                Text(challenge.category.rawValue)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(categoryColor.opacity(0.15))
                    )
                    .foregroundColor(categoryColor)
            }
            
            // Challenge title or placeholder
            if isRevealed {
                Text(challenge.title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppColor.textLabel)
                    .transition(.opacity.combined(with: .scale))
            } else {
                VStack(spacing: 8) {
                    Image(systemName: Constants.SystemImages.eyeSlash)
                        .font(.title2)
                        .foregroundColor(AppColor.subtext)
                        .scaleEffect(animateCard ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateCard)
                    
                    Text(Constants.Challenge.challengeHidden)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColor.subtext)
                    
                    Text(Constants.Challenge.tapToReveal)
                        .font(.caption)
                        .foregroundColor(AppColor.subtext)
                        .multilineTextAlignment(.center)
                }
                .padding(.vertical, 20)
            }
            
            // Challenge description
            if isRevealed {
                ScrollView {
                    Text(challenge.description)
                        .font(.body)
                        .foregroundColor(AppColor.subtext)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)
                        .padding(.horizontal, 4)
                }
                .frame(maxHeight: 120) // Limit height for very long descriptions
                .transition(.opacity.combined(with: .scale))
            }
            
            // Challenge details
            if isRevealed {
                HStack(spacing: 30) {
                    DetailItem(
                        icon: Constants.SystemImages.clock,
                        title: Constants.Challenge.timeRemaining,
                        value: "\(challenge.estimatedTime) \(Constants.Time.minutes)",
                        color: AppColor.appPrimary
                    )
                    
                    DetailItem(
                        icon: Constants.SystemImages.gauge,
                        title: Constants.Challenge.difficulty,
                        value: challenge.difficulty.rawValue,
                        color: difficultyColor
                    )
                }
                .transition(.opacity.combined(with: .scale))
            }
            
            // Timer (if challenge is accepted)
            if isAccepted && !isCompleted {
                TimerView(timeRemaining: timeRemaining)
                    .transition(.opacity.combined(with: .scale))
            }
            
            // Completion status
            if isCompleted {
                HStack(spacing: 12) {
                    Image(systemName: Constants.SystemImages.success)
                        .font(.title2)
                        .foregroundColor(AppColor.success)
                    
                    Text(Constants.Success.challengeCompleted)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(AppColor.success)
                }
                .transition(.opacity.combined(with: .scale))
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(AppColor.card)
                .shadow(color: Color.black.opacity(0.08), radius: 16, x: 0, y: 8)
        )
        .scaleEffect(isRevealed ? 1 : 0.95)
        .opacity(isRevealed ? 1 : 0.8)
        .onAppear {
            animateCard = true
        }
    }
}
