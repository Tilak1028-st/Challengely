//
//  LoadingView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var animate = false
    
    var body: some View {
        VStack(spacing: 20) {
            ProgressView()
                .scaleEffect(1.5)
                .tint(Color("AppPrimaryColor"))
            
            Text(Constants.Challenge.loadingChallenge)
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color("Subtext"))
        }
        .padding(40)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Card"))
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
        )
        .scaleEffect(animate ? 1.02 : 1.0)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                animate = true
            }
        }
    }
}
