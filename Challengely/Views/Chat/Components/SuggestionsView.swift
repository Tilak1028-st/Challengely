//
//  SuggestionsView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct SuggestionsView: View {
    let suggestions: [ChatSuggestion]
    let onSuggestionTapped: (ChatSuggestion) -> Void
    @State private var animateButtons = false
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Quick Questions")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color("TextLabel"))
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(animateButtons ? 1.0 : 0.0)
                .offset(x: animateButtons ? 0 : -20)
                .animation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1), value: animateButtons)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(Array(suggestions.enumerated()), id: \.element.id) { index, suggestion in
                        Button(action: {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.6)) {
                                onSuggestionTapped(suggestion)
                            }
                        }) {
                            Text(suggestion.text)
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(Color.blue.opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 20)
                                                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
                                        )
                                )
                        }
                        .buttonStyle(PlainButtonStyle())
                        .scaleEffect(animateButtons ? 1.0 : 0.8)
                        .opacity(animateButtons ? 1.0 : 0.0)
                        .offset(y: animateButtons ? 0 : 20)
                        .animation(
                            .spring(response: 0.6, dampingFraction: 0.7)
                            .delay(Double(index) * 0.1),
                            value: animateButtons
                        )
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    animateButtons = true
                }
            }
        }
        .onDisappear {
            animateButtons = false
        }
    }
} 
