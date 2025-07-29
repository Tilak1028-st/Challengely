//
//  TimerView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct TimerView: View {
    let timeRemaining: Int
    @State private var pulse = false
    
    var body: some View {
        VStack(spacing: 12) {
            Text("⏱️ Time Remaining")
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color("Subtext"))
            
            Text(timeString)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
                .foregroundColor(Color("AppPrimaryColor"))
                .scaleEffect(pulse ? 1.05 : 1.0)
                .animation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: pulse)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("AppPrimaryColor").opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("AppPrimaryColor").opacity(0.2), lineWidth: 1)
                )
        )
        .onAppear {
            pulse = true
        }
    }
    
    private var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}
