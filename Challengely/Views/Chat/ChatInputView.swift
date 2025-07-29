//
//  ChatInputView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI
import Foundation

/// Expandable text input component for chat messages with character limit and send functionality
struct ChatInputView: View {
    @EnvironmentObject var obj: Observed
    @Binding var messageText: String
    @Binding var isExpanded: Bool
    @Binding var isFocused: Bool
    let characterLimit: Int
    let isSending: Bool
    var onSend: () -> Void
    
    @State private var textHeight: CGFloat = 44

    // MARK: - Computed Properties
    
    private var characterCount: Int {
        messageText.count
    }
    
    private var characterCountColor: Color {
        if characterCount > characterLimit {
            return AppColor.challengeRed
        } else if characterCount > Int(Double(characterLimit) * 0.8) {
            return AppColor.accent
        } else {
            return AppColor.subtext
        }
    }
    
    private var isOverLimit: Bool {
        characterCount > characterLimit
    }
    
    private var inputHeight: CGFloat {
        if messageText.count > 50 || messageText.contains("\n") {
            return min(max(44, textHeight), 120)
        } else {
            return 44
        }
    }

    var body: some View {
        VStack(spacing: 8) {
            // Character counter (shown when typing)
            if characterCount > 0 {
                HStack {
                    Spacer()
                    Text("\(characterCount)/\(characterLimit)")
                        .font(.caption2)
                        .foregroundColor(characterCountColor)
                        .padding(.horizontal, 16)
                }
            }
            
            // Input area with send button
            HStack(alignment: .bottom, spacing: 12) {
                ZStack(alignment: .topLeading) {
                    MultiTextField(text: $messageText)
                        .frame(height: self.obj.size < 120 ? self.obj.size : 120)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(AppColor.card)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                        .overlay(
                            RoundedRectangle(cornerRadius: 24)
                                .stroke(
                                    isFocused ? AppColor.appPrimary.opacity(0.3) : AppColor.divider,
                                    lineWidth: isFocused ? 1.5 : 1
                                )
                        )
                        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                        
                }

                // Send button with loading state
                Button(action: {
                    if !isOverLimit && !isSending {
                        onSend()
                        messageText = ""
                        isExpanded = false
                    }
                }) {
                    Group {
                        if isSending {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        } else {
                            Image(systemName: Constants.SystemImages.send)
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        messageText.isEmpty || isOverLimit || isSending
                        ? AppColor.subtext.opacity(0.3)
                        : AppColor.appPrimary
                    )
                    .clipShape(Circle())
                    .shadow(color: Color.black.opacity(0.1), radius: 3, x: 0, y: 2)
                }
                .disabled(messageText.isEmpty || isOverLimit || isSending)
                .scaleEffect(messageText.isEmpty || isOverLimit || isSending ? 0.95 : 1.0)
                .animation(.easeInOut(duration: 0.2), value: messageText.isEmpty || isOverLimit || isSending)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            AppColor.background
                .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: -2)
        )
    }
}

#Preview {
    ChatInputView(
        messageText: .constant(""),
        isExpanded: .constant(false),
        isFocused: .constant(false),
        characterLimit: 500,
        isSending: false
    ) {
        print("Send tapped")
    }
}
