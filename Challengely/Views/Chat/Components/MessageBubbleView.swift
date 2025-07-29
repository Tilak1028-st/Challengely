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
                                .fill(AppColor.appPrimary)
                        )
                    
                    // User avatar
                    Image(systemName: Constants.SystemImages.userAvatar)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [AppColor.accent, AppColor.success]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                        )
                }
            } else {
                HStack(alignment: .bottom, spacing: 8) {
                    // Assistant avatar
                    Image(systemName: Constants.SystemImages.assistantAvatar)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.white)
                        .frame(width: 32, height: 32)
                        .background(
                            Circle()
                                .fill(LinearGradient(
                                    gradient: Gradient(colors: [AppColor.appPrimary, AppColor.accent]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ))
                        )
                    
                    Text(message.content)
                        .font(.body)
                        .foregroundColor(AppColor.textLabel)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 18)
                                .fill(AppColor.card)
                        )
                }
                
                Spacer(minLength: 60)
            }
        }
        .transition(.opacity.combined(with: .scale))
    }
}
