//
//  CompletionView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct CompletionView: View {
    let challenge: Challenge
    let onShare: () -> Void
    @State private var animateCompletion = false
    
    var body: some View {
        VStack(spacing: 25) {
            // Celebration icon
            Image(systemName: "party.popper.fill")
                .font(.system(size: 40))
                .foregroundColor(Color("Success"))
                .scaleEffect(animateCompletion ? 1.2 : 1.0)
                .animation(.easeInOut(duration: 0.6).repeatForever(autoreverses: true), value: animateCompletion)
            
            VStack(spacing: 12) {
                Text("🎉 Congratulations! 🎉")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("Success"))
                
                Text("You've completed today's challenge!")
                    .font(.body)
                    .foregroundColor(Color("Subtext"))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            
            Button(action: onShare) {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.title3)
                    Text("Share Achievement")
                        .font(.headline)
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color("AppPrimaryColor"))
                )
                .shadow(color: Color("AppPrimaryColor").opacity(0.3), radius: 8, x: 0, y: 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color("Success").opacity(0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("Success").opacity(0.2), lineWidth: 2)
                )
        )
        .onAppear {
            animateCompletion = true
        }
    }
}
