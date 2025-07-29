import Foundation

struct Challenge: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    let estimatedTime: Int // in minutes
    let difficulty: UserProfile.DifficultyLevel
    let category: UserProfile.Interest
    let date: Date
    
    var isCompleted: Bool = false
    var completionTime: Date?
    var timeSpent: Int? // in minutes
    
    static let sampleChallenges: [Challenge] = [
        Challenge(
            title: "Mindful Morning Meditation",
            description: "Start your day with 10 minutes of guided meditation. Find a quiet space, sit comfortably, and focus on your breath.",
            estimatedTime: 10,
            difficulty: .easy,
            category: .mindfulness,
            date: Date()
        ),
        Challenge(
            title: "Creative Sketch Session",
            description: "Draw something from your imagination for 15 minutes. Don't worry about perfection - just let your creativity flow!",
            estimatedTime: 15,
            difficulty: .medium,
            category: .creativity,
            date: Date()
        ),
        Challenge(
            title: "Learn Something New",
            description: "Spend 20 minutes learning about a topic you've always been curious about. Watch a video, read an article, or listen to a podcast.",
            estimatedTime: 20,
            difficulty: .medium,
            category: .learning,
            date: Date()
        ),
        Challenge(
            title: "Quick Workout",
            description: "Complete a 15-minute bodyweight workout. Include push-ups, squats, and planks. Challenge yourself but listen to your body.",
            estimatedTime: 15,
            difficulty: .medium,
            category: .fitness,
            date: Date()
        ),
        Challenge(
            title: "Reach Out to a Friend",
            description: "Send a thoughtful message to someone you haven't talked to in a while. Share something positive or ask how they're doing.",
            estimatedTime: 5,
            difficulty: .easy,
            category: .social,
            date: Date()
        )
    ]
} 