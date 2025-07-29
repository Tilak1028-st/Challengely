//
//  ProfileHeaderView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct ProfileHeaderView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var animateAvatar = false
    @State private var animateText = false
    @State private var showGlow = false
    @State private var pulseScale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 24) {
            // Enhanced Avatar with animations
            ZStack {
                // Outer glow ring
                Circle()
                    .stroke(AppColor.appPrimary.opacity(0.2), lineWidth: 3)
                    .frame(width: 120, height: 120)
                    .scaleEffect(showGlow ? 1.2 : 1.0)
                    .opacity(showGlow ? 0.0 : 1.0)
                    .animation(.easeOut(duration: 2.0).repeatForever(autoreverses: false), value: showGlow)
                
                // Pulse ring
                Circle()
                    .stroke(AppColor.accent.opacity(0.3), lineWidth: 2)
                    .frame(width: 110, height: 110)
                    .scaleEffect(pulseScale)
                    .opacity(pulseScale > 1.0 ? 0.0 : 0.5)
                    .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: false), value: pulseScale)
                
                // Main avatar
                Circle()
                    .fill(LinearGradient(
                        gradient: Gradient(colors: [
                            AppColor.appPrimary,
                            AppColor.accent,
                            AppColor.success
                        ]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 100, height: 100)
                    .shadow(color: AppColor.appPrimary.opacity(0.3), radius: 15, x: 0, y: 8)
                    .scaleEffect(animateAvatar ? 1.0 : 0.8)
                    .rotationEffect(.degrees(animateAvatar ? 0 : -10))
                
                // Avatar icon
                Image(systemName: "person.circle.fill")
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.white)
                    .scaleEffect(animateAvatar ? 1.0 : 0.9)
                    .opacity(animateAvatar ? 1.0 : 0.7)
                
                // Achievement badge
                ZStack {
                    Circle()
                        .fill(AppColor.confettiYellow)
                        .frame(width: 28, height: 28)
                    
                    Image(systemName: "star.fill")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.white)
                }
                .offset(x: 35, y: -35)
                .scaleEffect(animateAvatar ? 1.0 : 0.5)
                .opacity(animateAvatar ? 1.0 : 0.0)
            }
            
            // Enhanced text content
            VStack(spacing: 12) {
                Text("Challenge Champion")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.textLabel)
                    .opacity(animateText ? 1.0 : 0.0)
                    .offset(y: animateText ? 0 : 10)
                
                HStack(spacing: 16) {
                    // Level badge
                    HStack(spacing: 6) {
                        Image(systemName: "trophy.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColor.confettiYellow)
                        
                        Text("Level \(calculateLevel())")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColor.appPrimary)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColor.appPrimary.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColor.appPrimary.opacity(0.15), lineWidth: 1)
                            )
                    )
                    
                    // Interests badge
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(AppColor.challengeRed)
                        
                        Text("\(dataManager.userProfile.interests.count) Interests")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(AppColor.accent)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(AppColor.accent.opacity(0.08))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(AppColor.accent.opacity(0.15), lineWidth: 1)
                            )
                    )
                }
                .opacity(animateText ? 1.0 : 0.0)
                .offset(y: animateText ? 0 : 10)
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(AppColor.card)
                .shadow(color: Color.black.opacity(0.08), radius: 20, x: 0, y: 10)
                .overlay(
                    RoundedRectangle(cornerRadius: 28)
                        .stroke(
                            LinearGradient(
                                colors: [
                                    AppColor.appPrimary.opacity(0.15),
                                    AppColor.accent.opacity(0.08),
                                    Color.clear
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1
                        )
                )
        )
        .onAppear {
            startAnimations()
        }
    }
    
    private func calculateLevel() -> Int {
        let completed = dataManager.userProfile.totalChallengesCompleted
        return max(1, (completed / 5) + 1)
    }
    
    private func startAnimations() {
        // Start pulse animation
        showGlow = true
        pulseScale = 1.3
        
        // Animate avatar
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.2)) {
            animateAvatar = true
        }
        
        // Animate text
        withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.4)) {
            animateText = true
        }
        
        // Haptic feedback
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            HapticManager.shared.impact(style: .light)
        }
    }
}
