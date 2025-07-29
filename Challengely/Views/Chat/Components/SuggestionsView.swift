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
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Quick Questions")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(Color("TextLabel"))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(suggestions) { suggestion in
                        Button(action: {
                            onSuggestionTapped(suggestion)
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
                        .scaleEffect(1.0)
                        .animation(.easeInOut(duration: 0.2), value: true)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
    }
} 
