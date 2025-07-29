import SwiftUI

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
    private let characterLimit = 500
    private let sendCooldown: TimeInterval = 1.0 // 1 second cooldown between messages
    
    var body: some View {
        NavigationView {
            ZStack {
                // Enhanced gradient background
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color("PrimaryColor").opacity(0.08),
                        Color("Accent").opacity(0.05),
                        Color("PrimaryDark").opacity(0.03)
                    ]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                .onTapGesture {
                    dismissKeyboard()
                }
                
                VStack(spacing: 0) {
                    // Messages list
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 16) {
                                // Welcome message
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
                                    .frame(height: 1)
                                    .id("bottom")
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                            .padding(.bottom, 20)
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
                    }
                    .onTapGesture {
                        dismissKeyboard()
                    }
                    

                    
                    // Suggestions
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
                    
                    // Input area with character counter
                    ChatInputView(
                        messageText: $messageText,
                        isExpanded: $isInputExpanded,
                        isFocused: Binding(
                            get: { isInputFocused },
                            set: { isInputFocused = $0 }
                        ),
                        characterLimit: characterLimit,
                        isSending: isSendingMessage
                    ) {
                        sendMessage(messageText)
                    }
                    .onChange(of: messageText) { newValue in
                        let wasTyping = isUserTyping
                        let isNowTyping = !newValue.isEmpty
                        
                        if wasTyping != isNowTyping {
                            withAnimation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0.2)) {
                                isUserTyping = isNowTyping
                            }
                            
                            // Haptic feedback
                            if isNowTyping {
                                HapticManager.shared.impact(style: .light)
                            } else {
                                HapticManager.shared.impact(style: .soft)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Challenge Assistant")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Clear") {
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
    
    private func sendMessage(_ text: String) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
        
        // Show typing indicator with realistic delay
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
                
                wordIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                withAnimation(.easeInOut(duration: 0.3)) {
                    keyboardHeight = keyboardFrame.height
                }
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                keyboardHeight = 0
                // Reset typing state when keyboard is dismissed
                if messageText.isEmpty {
                    isUserTyping = false
                }
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
