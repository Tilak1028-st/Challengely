import SwiftUI

struct ChatView: View {
    @EnvironmentObject var dataManager: DataManager
    @StateObject private var chatService = ChatService()
    @State private var messageText = ""
    @State private var isInputExpanded = false
    @State private var keyboardHeight: CGFloat = 0
    @FocusState private var isInputFocused: Bool
    
    
    private let maxInputHeight: CGFloat = 120
    private let characterLimit = 500
    
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
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            // Welcome message
                            if dataManager.chatMessages.isEmpty {
                                WelcomeMessageView()
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
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 20)
                    }
                    .onTapGesture {
                        dismissKeyboard()
                    }
                    
                    // Suggestions
                    if dataManager.chatMessages.isEmpty {
                        SuggestionsView(
                            suggestions: chatService.getSuggestions(for: dataManager.currentChallenge),
                            onSuggestionTapped: { suggestion in
                                sendMessage(suggestion.text)
                            }
                        )
                    }
                    
                    // Input area
                    ChatInputView(messageText: $messageText) {
                                    print("Send tapped: \(messageText)")
                                    // Handle message sending here
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
        }
        .onDisappear {
            removeKeyboardObservers()
        }
    }
    
    private func sendMessage(_ text: String) {
        guard !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        // Add user message
        let userMessage = ChatMessage(content: text, isFromUser: true)
        dataManager.addChatMessage(userMessage)
        
        // Clear input
        messageText = ""
        isInputExpanded = false
        isInputFocused = false
        
        // Show typing indicator
        chatService.isTyping = true
        
        // Generate AI response
        Task {
            do {
                let response = try await chatService.generateResponse(
                    userMessage: text,
                    challenge: dataManager.currentChallenge,
                    userProfile: dataManager.userProfile
                )
                
                await MainActor.run {
                    chatService.isTyping = false
                    let aiMessage = ChatMessage(content: response, isFromUser: false)
                    dataManager.addChatMessage(aiMessage)
                }
            } catch {
                await MainActor.run {
                    chatService.isTyping = false
                    // Fallback to hardcoded response if API fails
                    let fallbackResponse = chatService.generateFallbackResponse(for: text, challenge: dataManager.currentChallenge)
                    let aiMessage = ChatMessage(content: fallbackResponse, isFromUser: false)
                    dataManager.addChatMessage(aiMessage)
                }
            }
        }
        
        HapticManager.shared.impact(style: .light)
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: .main
        ) { notification in
            if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
                keyboardHeight = keyboardFrame.height
            }
        }
        
        NotificationCenter.default.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: .main
        ) { _ in
            keyboardHeight = 0
        }
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func dismissKeyboard() {
        isInputFocused = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ChatView()
}
