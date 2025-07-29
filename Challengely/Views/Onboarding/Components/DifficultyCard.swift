//
//  DifficultyCard.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct DifficultyCard: View {
    let difficulty: UserProfile.DifficultyLevel
    let isSelected: Bool
    let namespace: Namespace.ID
    let action: () -> Void
    
    @State private var isPressed = false
    
    private var difficultyColor: Color {
        switch difficulty {
        case .easy: return Color("Success")
        case .medium: return Color("Accent")
        case .hard: return Color("ChallengeRed")
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 6) {
                    Text(difficulty.rawValue)
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(difficultyDescription)
                        .font(.subheadline)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : Color("Subtext"))
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: isSelected ? Constants.SystemImages.success : "circle")
                    .font(.title3)
                    .foregroundColor(isSelected ? .white : difficultyColor)
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(isSelected ? difficultyColor : difficultyColor.opacity(0.1))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(difficultyColor, lineWidth: isSelected ? 0 : 2)
                    )
            )
            .scaleEffect(isPressed ? 0.98 : (isSelected ? 1.01 : 1.0))
            .shadow(color: isSelected ? difficultyColor.opacity(0.3) : Color.clear, radius: 8, x: 0, y: 4)
            .zIndex(isSelected ? 1 : 0)
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.easeInOut(duration: 0.2), value: isSelected)
        .animation(.easeInOut(duration: 0.1), value: isPressed)
        .onLongPressGesture(minimumDuration: 0, maximumDistance: .infinity, pressing: { pressing in
            isPressed = pressing
        }, perform: {})
    }
    
    private var difficultyDescription: String {
        switch difficulty {
        case .easy:
            return "Gentle challenges to build confidence 🌱"
        case .medium:
            return "Balanced challenges for steady growth ⚖️"
        case .hard:
            return "Ambitious challenges to push limits 🔥"
        }
    }
}
