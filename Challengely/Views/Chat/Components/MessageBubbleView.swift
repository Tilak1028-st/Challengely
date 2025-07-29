//
//  MessageBubbleView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromUser {
                Spacer(minLength: 60)
                
                HStack(alignment: .bottom, spacing: 8) {
                    Text(message.content)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color("AppPrimaryColor"))
                        )
                    
                    // User avatar
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color("Accent"), Color("Success")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                        )
                }
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    // Assistant avatar
                    Image(systemName: "brain.head.profile")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [Color("AppPrimaryColor"), Color("Accent")]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                        )
                    
                    Text(message.content)
                        .font(.body)
                        .foregroundColor(Color("TextLabel"))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(Color("Card"))
                        )
                }
                
                Spacer(minLength: 60)
            }
        }
        .transition(.opacity.combined(with: .scale))
    }
}
