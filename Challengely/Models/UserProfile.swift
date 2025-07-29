import Foundation

struct UserProfile: Codable {
    var interests: [Interest] = []
    var difficultyPreference: DifficultyLevel = .medium
    var hasCompletedOnboarding: Bool = false
    var currentStreak: Int = 0
    var longestStreak: Int = 0
    var totalChallengesCompleted: Int = 0
    var lastChallengeDate: Date?
    
    enum Interest: String, CaseIterable, Codable {
        case fitness = "Fitness"
        case creativity = "Creativity"
        case mindfulness = "Mindfulness"
        case learning = "Learning"
        case social = "Social"
        
        var icon: String {
            switch self {
            case .fitness: return "figure.run"
            case .creativity: return "paintbrush"
            case .mindfulness: return "brain.head.profile"
            case .learning: return "book"
            case .social: return "person.2"
            }
        }
        
        var color: String {
            switch self {
            case .fitness: return "ChallengeRed"
            case .creativity: return "PrimaryDark"
            case .mindfulness: return "AppPrimaryColor"
            case .learning: return "Success"
            case .social: return "Accent"
            }
        }
    }
    
    enum DifficultyLevel: String, CaseIterable, Codable {
        case easy = "Easy"
        case medium = "Medium"
        case hard = "Hard"
        
        var color: String {
            switch self {
            case .easy: return "Success"
            case .medium: return "Accent"
            case .hard: return "ChallengeRed"
            }
        }
    }
} 
