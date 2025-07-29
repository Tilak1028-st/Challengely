//
//  FullScreenTextView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

/// Full-screen text input view for composing longer messages
struct FullScreenTextView: View {
    @Binding var text: String
    @Binding var isPresented: Bool
    let characterLimit: Int
    let onSend: () -> Void
    
    @State private var isSending = false
    @FocusState private var isFocused: Bool
    
    private var characterCount: Int {
        text.count
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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Text input area
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $text)
                        .font(.body)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(AppColor.card)
                        .focused($isFocused)
                        .onAppear {
                            isFocused = true
                        }
                    
                    // Placeholder text
                    if text.isEmpty {
                        Text(Constants.Placeholder.typeSomething)
                            .foregroundColor(AppColor.subtext)
                            .font(.body)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 16)
                            .allowsHitTesting(false)
                    }
                }
                
                // Bottom toolbar
                VStack(spacing: 8) {
                    // Character counter
                    HStack {
                        Text("\(characterCount)/\(characterLimit)")
                            .font(.caption)
                            .foregroundColor(characterCountColor)
                        
                        Spacer()
                        
                        // Send button
                        Button(action: {
                            if !isOverLimit && !isSending && !text.isEmpty {
                                isSending = true
                                onSend()
                                // Dismiss view
                                isPresented = false
                                isSending = false
                            }
                        }) {
                            HStack(spacing: 6) {
                                if isSending {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: Constants.SystemImages.send)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                
                                Text(Constants.Button.send)
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                text.isEmpty || isOverLimit || isSending
                                ? AppColor.subtext.opacity(0.3)
                                : AppColor.appPrimary
                            )
                            .clipShape(Capsule())
                        }
                        .disabled(text.isEmpty || isOverLimit || isSending)
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .background(AppColor.background)
            }
            .navigationTitle(Constants.Navigation.newMessage)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(Constants.Button.cancel) {
                        isPresented = false
                    }
                    .foregroundColor(AppColor.appPrimary)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Constants.Button.done) {
                        isPresented = false
                    }
                    .foregroundColor(AppColor.appPrimary)
                }
            }
        }
        .background(AppColor.background)
    }
}

#Preview {
    FullScreenTextView(
        text: .constant(""),
        isPresented: .constant(true),
        characterLimit: 500
    ) {
        print("Send tapped")
    }
} 