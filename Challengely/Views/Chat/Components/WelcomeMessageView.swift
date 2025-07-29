//
//  WelcomeMessageView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct WelcomeMessageView: View {
    @State private var animateWelcome = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Assistant avatar
            Image(systemName: Constants.SystemImages.robot)
                .font(.system(size: 50, weight: .semibold))
                .foregroundColor(Color("AppPrimaryColor"))
                .scaleEffect(animateWelcome ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateWelcome)
            
            VStack(spacing: 12) {
                Text(Constants.Chat.welcomeTitle)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("TextLabel"))
                
                Text(Constants.Chat.welcomeMessage)
                    .font(.body)
                    .foregroundColor(.subtext)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Card"))
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
        )
        .onAppear {
            animateWelcome = true
        }
    }
}
