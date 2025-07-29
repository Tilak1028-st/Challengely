//
//  InterestCard.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct InterestCard: View {
    let interest: UserProfile.Interest
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    @State private var isPressed = false
    
    private var interestColor: Color {
        switch interest {
        case .fitness: return Color("ChallengeRed")
        case .creativity: return Color("PrimaryDark")
        case .mindfulness: return Color("PrimaryColor")
        case .learning: return Color("Success")
        case .social: return Color("Accent")
        }
    }
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 16) {
                Image(systemName: interest.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : interestColor)
                
                Text(interest.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : Color("TextLabel"))
            }
            .frame(height: 105)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? interestColor : interestColor.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(interestColor, lineWidth: isSelected ? 0 : 2)
                    )
            )
            .scaleEffect(isPressed ? 0.95 : (isSelected ? 1.02 : 1.0))
            .shadow(color: isSelected ? interestColor.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            .zIndex(isSelected ? 1 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
}
