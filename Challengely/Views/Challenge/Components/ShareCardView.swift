//
//  ShareCardView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct ShareCardView: View {
    let challenge: Challenge
    let streak: Int
    @State private var animateElements = false
    
    var body: some View {
        VStack(spacing: 25) {
                            // Header
                VStack(spacing: 12) {
                    Image(systemName: "trophy.fill")
                        .font(.system(size: 36))
                        .foregroundColor(AppColor.confettiYellow)
                        .scaleEffect(animateElements ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateElements)
                    
                    Text(Constants.Success.challengeCompleted)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(AppColor.textLabel)
                }
            
            // Challenge info
            VStack(spacing: 20) {
                Text(challenge.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(AppColor.textLabel)
                    .lineSpacing(4)
                
                HStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text("\(challenge.estimatedTime)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColor.appPrimary)
                        
                        Text(Constants.Time.minutes)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(AppColor.subtext)
                    }
                    
                    VStack(spacing: 8) {
                        Text("\(streak)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(AppColor.accent)
                        
                        Text("\(Constants.Time.days) streak")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(AppColor.subtext)
                    }
                }
            }
            
            // Footer
            VStack(spacing: 6) {
                Text(Constants.App.name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(AppColor.subtext)
                
                Text(Constants.App.tagline)
                    .font(.caption2)
                    .foregroundColor(AppColor.subtext)
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    AppColor.appPrimary.opacity(0.08),
                    AppColor.accent.opacity(0.05),
                    AppColor.primaryDark.opacity(0.03)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColor.appPrimary.opacity(0.2), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            animateElements = true
        }
    }
}
