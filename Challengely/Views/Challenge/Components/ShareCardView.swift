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
                        .foregroundColor(Color("ConfettiYellow"))
                        .scaleEffect(animateElements ? 1.1 : 1.0)
                        .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: animateElements)
                    
                    Text(Constants.Success.challengeCompleted)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color("TextLabel"))
                }
            
            // Challenge info
            VStack(spacing: 20) {
                Text(challenge.title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("TextLabel"))
                    .lineSpacing(4)
                
                HStack(spacing: 30) {
                    VStack(spacing: 8) {
                        Text("\(challenge.estimatedTime)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("AppPrimaryColor"))
                        
                        Text(Constants.Time.minutes)
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color("Subtext"))
                    }
                    
                    VStack(spacing: 8) {
                        Text("\(streak)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("Accent"))
                        
                        Text("\(Constants.Time.days) streak")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(Color("Subtext"))
                    }
                }
            }
            
            // Footer
            VStack(spacing: 6) {
                Text(Constants.App.name)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Subtext"))
                
                Text(Constants.App.tagline)
                    .font(.caption2)
                    .foregroundColor(Color("Subtext"))
            }
        }
        .padding(24)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [
                    Color("AppPrimaryColor").opacity(0.08),
                    Color("Accent").opacity(0.05),
                    Color("PrimaryDark").opacity(0.03)
                ]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color("AppPrimaryColor").opacity(0.2), lineWidth: 2)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onAppear {
            animateElements = true
        }
    }
}
