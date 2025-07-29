import Foundation

class ChatService: ObservableObject {
    @Published var isTyping = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var typingTimer: Timer?
    
    // MARK: - System Prompt
    private let systemPrompt = """
    You are a friendly, motivational challenge assistant inside a personal development app called "Challengely". 
    
    Your personality:
    - Encouraging, supportive, and inspiring tone
    - Speak briefly and conversationally (under 100 words)
    - Show empathy and understanding for user struggles
    - Provide actionable advice and motivation
    - Use challenge-themed language occasionally (🎯, 💪, 🚀, ✨)
    - Celebrate progress and effort, not just completion
    
    Your role:
    - Help users with their daily challenges (fitness, creativity, mindfulness, learning, social)
    - Provide emotional support and motivation
    - Offer practical tips and strategies
    - Help users overcome obstacles and build habits
    - Encourage reflection and growth mindset
    
    Always respond as a supportive coach and friend, focusing on personal development and growth.
    """
    
    // MARK: - Generate Response (Fallback System)
    func generateResponse(
        userMessage: String,
        challenge: Challenge?,
        userProfile: UserProfile?
    ) async throws -> String {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        // Simulate network delay
        try await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        await MainActor.run {
            isLoading = false
        }
        
        return generateFallbackResponse(for: userMessage, challenge: challenge)
    }
    
    // MARK: - Hardcoded Response System
    func generateFallbackResponse(for userMessage: String, challenge: Challenge?) -> String {
        let lowercasedMessage = userMessage.lowercased()
        
        // Challenge-related responses
        if lowercasedMessage.contains("challenge") || lowercasedMessage.contains("what") {
            if let challenge = challenge {
                return "Your challenge today is: \(challenge.title) 🎯\n\nIt's a \(challenge.difficulty.rawValue.lowercased()) \(challenge.category.rawValue.lowercased()) challenge that should take about \(challenge.estimatedTime) minutes. Ready to tackle it? 💪"
            } else {
                return "I don't see a challenge for today yet! Check back later or try refreshing the app. ✨"
            }
        }
        
        // Motivation responses
        if lowercasedMessage.contains("motivation") || lowercasedMessage.contains("motivate") {
            return "You've got this! 💪 Every challenge is a step toward becoming your best self. Remember why you started - you're building habits that will last a lifetime. Take it one moment at a time! ✨"
        }
        
        // Tips responses
        if lowercasedMessage.contains("tip") || lowercasedMessage.contains("help") || lowercasedMessage.contains("advice") {
            if let challenge = challenge {
                switch challenge.category {
                case .fitness:
                    return "For fitness challenges: Start small, focus on form over speed, and remember to breathe! Even 5 minutes of movement counts. You're doing great! 🏃‍♀️"
                case .mindfulness:
                    return "For mindfulness: Find a quiet spot, focus on your breath, and don't worry about clearing your mind completely. It's normal for thoughts to wander - just gently bring your attention back. 🧘‍♀️"
                case .creativity:
                    return "For creativity: Don't overthink it! Start with whatever comes to mind first. There are no wrong answers in creativity. Let your imagination run wild! 🎨"
                case .learning:
                    return "For learning: Break it down into smaller chunks, take notes, and don't be afraid to ask questions. Learning is a journey, not a race! 📚"
                case .social:
                    return "For social challenges: Be genuine, listen actively, and remember that everyone appreciates kindness. You have something valuable to share! 🤝"
                }
            } else {
                return "My best tip: Start where you are, use what you have, and do what you can. Every small step counts toward your bigger goals! ✨"
            }
        }
        
        // Progress/streak responses
        if lowercasedMessage.contains("progress") || lowercasedMessage.contains("streak") || lowercasedMessage.contains("doing") {
            return "You're making amazing progress! Every challenge you complete builds your confidence and strengthens your habits. Keep going - you're building something incredible! 🔥"
        }
        
        // Nervous/anxious responses
        if lowercasedMessage.contains("nervous") || lowercasedMessage.contains("anxious") || lowercasedMessage.contains("worried") {
            return "It's totally normal to feel nervous! Remember, challenges are meant to stretch you, not break you. Start with just 5 minutes and see how it feels. You're stronger than you think! 💪"
        }
        
        // Distracted responses
        if lowercasedMessage.contains("distract") || lowercasedMessage.contains("focus") {
            return "Distractions happen to everyone! Try counting your breaths from 1 to 10, then repeat. When your mind wanders, gently bring it back. It's like training a muscle - it gets stronger with practice! 🧠"
        }
        
        // Completion responses
        if lowercasedMessage.contains("complete") || lowercasedMessage.contains("done") || lowercasedMessage.contains("finished") {
            return "Congratulations! 🎉 You did it! How did it feel? What was the most challenging part? Take a moment to celebrate your accomplishment - you earned it! ✨"
        }
        
        // Default encouraging response
        return "I'm here to support you on your challenge journey! 💪 What would you like to know about your challenge or how can I help motivate you today?"
    }
    
    // MARK: - Construct Prompt
    private func constructPrompt(
        userMessage: String,
        challenge: Challenge?,
        userProfile: UserProfile?
    ) -> String {
        var context = "User context: "
        
        if let challenge = challenge {
            context += "Current challenge: \(challenge.title) (\(challenge.category.rawValue)), difficulty: \(challenge.difficulty.rawValue), estimated time: \(challenge.estimatedTime) minutes. "
        } else {
            context += "No current challenge available. "
        }
        
        if let profile = userProfile {
            context += "User interests: \(profile.interests.map { $0.rawValue }.joined(separator: ", ")). "
            context += "Preferred difficulty: \(profile.difficultyPreference.rawValue). "
            context += "Current streak: \(profile.currentStreak) days, total completed: \(profile.totalChallengesCompleted) challenges. "
        }
        
        context += "\n\nUser message: \(userMessage)"
        
        return context
    }
    
    func simulateTyping(delay: TimeInterval = 1.5, completion: @escaping () -> Void) {
        isTyping = true
        
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
            DispatchQueue.main.async {
                self.isTyping = false
                completion()
            }
        }
    }
    
    func getSuggestions(for challenge: Challenge?) -> [ChatSuggestion] {
        var suggestions: [ChatSuggestion] = []
        
        if let challenge = challenge {
            suggestions.append(ChatSuggestion(text: "What's my challenge today?", action: "challenge"))
            
            // Context-aware suggestions based on challenge type
            switch challenge.category {
            case .fitness:
                suggestions.append(ChatSuggestion(text: "I'm tired, any tips?", action: "fitness_tips"))
                suggestions.append(ChatSuggestion(text: "How do I stay motivated?", action: "motivation"))
            case .mindfulness:
                suggestions.append(ChatSuggestion(text: "I'm getting distracted", action: "focus"))
                suggestions.append(ChatSuggestion(text: "Help me relax", action: "relax"))
            case .creativity:
                suggestions.append(ChatSuggestion(text: "I'm stuck for ideas", action: "creativity_block"))
                suggestions.append(ChatSuggestion(text: "How do I get inspired?", action: "inspiration"))
            case .learning:
                suggestions.append(ChatSuggestion(text: "This is too hard", action: "difficulty"))
                suggestions.append(ChatSuggestion(text: "How do I remember this?", action: "memory"))
            case .social:
                suggestions.append(ChatSuggestion(text: "I'm nervous about this", action: "social_anxiety"))
                suggestions.append(ChatSuggestion(text: "What should I say?", action: "conversation"))
            }
        } else {
            suggestions = [
                ChatSuggestion(text: "What's my challenge today?", action: "challenge"),
                ChatSuggestion(text: "I need motivation", action: "motivation"),
                ChatSuggestion(text: "Give me some tips", action: "tips"),
                ChatSuggestion(text: "How am I doing?", action: "progress")
            ]
        }
        
        return suggestions
    }
} 
