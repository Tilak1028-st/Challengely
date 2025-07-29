//
//  ChatView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

/// Main chat interface for interacting with the Challenge Assistant
struct ChatView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var chatService = ChatService()
    @State private var messageText = ""
    @State private var isInputExpanded = false
    @State private var keyboardHeight: CGFloat = 0
    @State private var scrollToBottom = false
    @State private var isUserTyping = false
    @State private var isSendingMessage = false
    @State private var lastSentMessage = ""
    @State private var sendCooldownTimer: Timer?
    @FocusState private var isInputFocused: Bool
    
    private let maxInputHeight: CGFloat = 120
    private let characterLimit = Constants.Limits.messageLength
    private let sendCooldown: TimeInterval = 1.0
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        AppColor.appPrimary.opacity(0.08),
                        AppColor.accent.opacity(0.05),
                        AppColor.primaryDark.opacity(0.03)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .onTapGesture {
                    dismissKeyboard()
                }
                
                VStack(spacing: 0) {
                    // Messages list with auto-scroll
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                // Top spacer to ensure proper scrolling
                                Color.clear
                                    .frame(height: 1)
                                    .id("top")
                                // Welcome message for empty chat
                                if dataManager.chatMessages.isEmpty {
                                    WelcomeMessageView()
                                        .id("welcome")
                                }
                                
                                // Chat messages
                                ForEach(dataManager.chatMessages) { message in
                                    MessageBubbleView(message: message)
                                        .id(message.id)
                                }
                                
                                // Typing indicator
                                if chatService.isTyping {
                                    TypingIndicatorView()
                                        .id("typing")
                                }
                                
                                // Bottom spacer for auto-scroll
                                Color.clear
                                    .frame(height: messageText.isEmpty ? 1 : 30)
                                    .id("bottom")
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, messageText.isEmpty ? 20 : 40)
                        }
                        .onChange(of: dataManager.chatMessages.count) { _ in
                            withAnimation(.easeInOut(duration: 0.3)) {
                                proxy.scrollTo("bottom", anchor: .bottom)
                            }
                        }
                        .onChange(of: chatService.isTyping) { _ in
                            if chatService.isTyping {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    proxy.scrollTo("typing", anchor: .bottom)
                                }
                            }
                        }
                        .onChange(of: scrollToBottom) { shouldScroll in
                            if shouldScroll {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    // Use different anchor based on whether character counter is visible
                                    let anchor: UnitPoint = messageText.isEmpty ? .bottom : .bottom
                                    proxy.scrollTo("bottom", anchor: anchor)
                                }
                                scrollToBottom = false
                            }
                        }
                        .onAppear {
                            // Scroll to bottom when view appears
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    proxy.scrollTo("bottom", anchor: .bottom)
                                }
                            }
                        }
                    }
                    .onTapGesture {
                        dismissKeyboard()
                    }
                    
                    // Quick suggestions (hidden when typing)
                    if dataManager.chatMessages.isEmpty && !isUserTyping {
                        SuggestionsView(
                            suggestions: chatService.getSuggestions(for: dataManager.currentChallenge),
                            onSuggestionTapped: { suggestion in
                                sendMessage(suggestion.text)
                            }
                        )
                        .transition(.asymmetric(
                            insertion: .opacity.combined(with: .scale).combined(with: .offset(y: 20)),
                            removal: .opacity.combined(with: .scale).combined(with: .offset(y: 20))
                        ))
                        .animation(.spring(response: 0.5, dampingFraction: 0.7), value: isUserTyping)
                    }
                    
                    // Input area
                    ChatInputView(
                        messageText: $messageText,
                        isExpanded: $isInputExpanded,
                        isFocused: Binding(
                            get: { isInputFocused },
                            set: { isInputFocused = $0 }
                        ),
                        characterLimit: characterLimit,
                        isSending: isSendingMessage,
                        onSend: {
                            sendMessage(messageText)
                        },
                        onSendWithText: { text in
                            sendMessageWithText(text)
                        }
                    )
                    .onChange(of: messageText) { newValue in
                        let wasTyping = isUserTyping
                        let isNowTyping = !newValue.isEmpty
                        
                        if wasTyping != isNowTyping {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                                isUserTyping = isNowTyping
                            }
                            
                            // Haptic feedback for typing state change
                            if isNowTyping {
                                HapticManager.shared.impact(style: .light)
                            } else {
                                HapticManager.shared.impact(style: .soft)
                            }
                            
                            // Scroll to bottom when character counter appears/disappears
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                scrollToBottom = true
                            }
                        }
                    }
                }
            }
            .navigationTitle(Constants.Navigation.assistant)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(Constants.Button.clear) {
                        dataManager.clearChatMessages()
                    }
                    .disabled(dataManager.chatMessages.isEmpty)
                }
            }
        }
        .onAppear {
            setupKeyboardObservers()
            setupAppStateObservers()
        }
        .onDisappear {
            removeKeyboardObservers()
            removeAppStateObservers()
        }
    }
    
    // MARK: - Message Handling
    
    private func sendMessage(_ text: String) {
        sendMessageWithText(text)
    }
    
    private func sendMessageWithText(_ inputText: String) {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Edge case: Empty message
        guard !trimmedText.isEmpty else { return }
        
        // Edge case: Rapid message sending prevention
        guard !isSendingMessage else { return }
        
        // Edge case: Duplicate message prevention (within cooldown)
        if trimmedText.lowercased() == lastSentMessage.lowercased() && sendCooldownTimer != nil {
            HapticManager.shared.impact(style: .rigid)
            return
        }
        
        // Edge case: Character limit exceeded
        guard trimmedText.count <= characterLimit else { return }
        
        isSendingMessage = true
        lastSentMessage = trimmedText
        
        // Add user message
        let userMessage = ChatMessage(content: trimmedText, isFromUser: true)
        dataManager.addChatMessage(userMessage)
        
        // Clear input
        messageText = ""
        isInputExpanded = false
        isInputFocused = false
        
        // Show typing indicator
        chatService.isTyping = true
        
        // Start cooldown timer
        sendCooldownTimer?.invalidate()
        sendCooldownTimer = Timer.scheduledTimer(withTimeInterval: sendCooldown, repeats: false) { _ in
            sendCooldownTimer = nil
        }
        
        // Generate AI response with streaming effect
        Task {
            do {
                let response = try await chatService.generateResponse(
                    userMessage: trimmedText,
                    challenge: dataManager.currentChallenge,
                    userProfile: dataManager.userProfile
                )
                
                await MainActor.run {
                    chatService.isTyping = false
                    isSendingMessage = false
                    
                    // Simulate streaming effect
                    simulateStreamingResponse(response)
                }
            } catch {
                await MainActor.run {
                    chatService.isTyping = false
                    isSendingMessage = false
                    // Fallback to hardcoded response if API fails
                    let fallbackResponse = chatService.generateFallbackResponse(for: trimmedText, challenge: dataManager.currentChallenge)
                    simulateStreamingResponse(fallbackResponse)
                }
            }
        }
        
        HapticManager.shared.impact(style: .light)
    }
    
    /// Simulates word-by-word streaming response for realistic AI interaction
    private func simulateStreamingResponse(_ fullResponse: String) {
        let words = fullResponse.components(separatedBy: " ")
        var currentResponse = ""
        var wordIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if wordIndex < words.count {
                currentResponse += (wordIndex == 0 ? "" : " ") + words[wordIndex]
                
                // Update or create AI message
                if let lastMessage = dataManager.chatMessages.last, !lastMessage.isFromUser {
                    // Update existing message
                    let updatedMessage = ChatMessage(
                        id: lastMessage.id,
                        content: currentResponse,
                        isFromUser: false,
                        timestamp: lastMessage.timestamp
                    )
                    dataManager.updateLastMessage(updatedMessage)
                } else {
                    // Create new message
                    let aiMessage = ChatMessage(content: currentResponse, isFromUser: false)
                    dataManager.addChatMessage(aiMessage)
                }
                
                // Ensure scroll to bottom for each word update
                scrollToBottom = true
                
                wordIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    // MARK: - Keyboard Management
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
                
                withAnimation(.easeInOut(duration: duration)) {
                    keyboardHeight = keyboardFrame.height
                }
                
                // Scroll to bottom when keyboard appears to keep last message visible
                DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.5) {
                    scrollToBottom = true
                }
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { notification in
            let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
            
            withAnimation(.easeInOut(duration: duration)) {
                keyboardHeight = 0
                // Reset typing state when keyboard is dismissed
                if messageText.isEmpty {
                    isUserTyping = false
                }
            }
            
            // Scroll to bottom when keyboard is dismissed
            DispatchQueue.main.asyncAfter(deadline: .now() + duration * 0.5) {
                scrollToBottom = true
            }
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func dismissKeyboard() {
        isInputFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        // Reset typing state when keyboard is dismissed
        if messageText.isEmpty {
            isUserTyping = false
        }
    }
    
    // MARK: - App State Management
    
    private func setupAppStateObservers() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willResignActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            // Save current state when app goes to background
            dataManager.saveChatMessages()
        }
        
        NotificationCenter.default.addObserver(
            forName: UIApplication.didBecomeActiveNotification,
            object: nil,
            queue: .main
        ) { _ in
            // Restore state when app becomes active
            // State is automatically restored from DataManager
        }
    }
    
    private func removeAppStateObservers() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
}

#Preview {
    ChatView()
        .environmentObject(DataManager())
}
