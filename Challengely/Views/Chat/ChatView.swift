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

struct WelcomeMessageView: View {
    @State private var animateWelcome = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Assistant avatar
            Image(systemName: "robot")
                .font(.system(size: 50, weight: .semibold))
                .foregroundColor(Color("PrimaryColor"))
                .scaleEffect(animateWelcome ? 1.1 : 1.0)
                .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: animateWelcome)
            
            VStack(spacing: 12) {
                Text("Hello! I'm your Challenge Assistant 🤖")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color("TextLabel"))
                
                Text("Ask me anything about today's challenge, get motivation, or share your progress!")
                    .font(.body)
                    .foregroundColor(.subtext)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
        }
        .padding(30)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("Card"))
                .shadow(color: Color.black.opacity(0.08), radius: 15, x: 0, y: 8)
        )
        .onAppear {
            animateWelcome = true
        }
    }
}

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
                                .fill(Color("PrimaryColor"))
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
                                    gradient: Gradient(colors: [Color("PrimaryColor"), Color("Accent")]),
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

struct TypingIndicatorView: View {
    @State private var dotOffset1: CGFloat = 0
    @State private var dotOffset2: CGFloat = 0
    @State private var dotOffset3: CGFloat = 0
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            // Assistant avatar
            Image(systemName: "brain.head.profile")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 32, height: 32)
                .background(
                    Circle()
                        .fill(LinearGradient(
                            gradient: Gradient(colors: [Color("PrimaryColor"), Color("Accent")]),
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ))
                )
            
            HStack(spacing: 6) {
                ForEach(0..<3, id: \.self) { index in
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 8, height: 8)
                        .offset(y: index == 0 ? dotOffset1 : index == 1 ? dotOffset2 : dotOffset3)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color("Card"))
            )
            
            Spacer(minLength: 60)
        }
        .onAppear {
            startTypingAnimation()
        }
    }
    
    private func startTypingAnimation() {
        let animation = Animation.easeInOut(duration: 0.6).repeatForever(autoreverses: true)
        
        withAnimation(animation.delay(0.0)) {
            dotOffset1 = -5
        }
        
        withAnimation(animation.delay(0.2)) {
            dotOffset2 = -5
        }
        
        withAnimation(animation.delay(0.4)) {
            dotOffset3 = -5
        }
    }
}

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
