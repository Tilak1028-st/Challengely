import Foundation
import AIProxy

let openAIService = AIProxy.openAIService(
    partialKey: "v2|ae30f6d3|aUPIsaYQU0na1axD",
    serviceURL: "https://api.aiproxy.com/1ba3f9db/68ff11e4"
)

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
    
    // MARK: - Generate Response (Async with OpenAI)
    func generateResponse(
        userMessage: String,
        challenge: Challenge?,
        userProfile: UserProfile?
    ) async throws -> String {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let prompt = constructPrompt(
                userMessage: userMessage,
                challenge: challenge,
                userProfile: userProfile
            )
            
            let response = try await openAIService.chatCompletionRequest(body: .init(
                model: "gpt-4o",
                messages: [
                    .system(content: .text(systemPrompt)),
                    .user(content: .text(prompt))
                ],
                maxTokens: 300,
                temperature: 0.7
            ), secondsToWait: 60)
            
            await MainActor.run {
                isLoading = false
            }
            
            return response.choices.first?.message.content ?? "I'm here to support you on your challenge journey! 💪"
            
        } catch {
            await MainActor.run {
                isLoading = false
                errorMessage = error.localizedDescription
            }
            throw error
        }
    }
    
    // MARK: - Fallback Response (for offline/error cases)
    func generateFallbackResponse(for userMessage: String, challenge: Challenge?) -> String {
        return "I'm having trouble connecting right now, but I'm here to support you! Try asking me about your challenge or how I can help motivate you. 💪"
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
        return [
            ChatSuggestion(text: "What's my challenge today?", action: "challenge"),
            ChatSuggestion(text: "I need motivation", action: "motivation"),
            ChatSuggestion(text: "Give me some tips", action: "tips"),
            ChatSuggestion(text: "How am I doing?", action: "progress")
        ]
    }
} 
