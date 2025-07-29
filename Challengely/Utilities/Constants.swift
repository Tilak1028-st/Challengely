//
//  Constants.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import Foundation
import SwiftUI

/// Centralized constants for all static strings used throughout the app
struct Constants {
    
    // MARK: - App Information
    struct App {
        static let name = "Challengely"
        static let tagline = "Transform your daily routine"
        static let version = "1.0.0"
    }
    
    // MARK: - Navigation Titles
    struct Navigation {
        static let challenge = "Today's Challenge"
        static let assistant = "Challenge Assistant"
        static let profile = "Profile"
    }
    
    // MARK: - Tab Labels
    struct Tab {
        static let challenge = "Challenge"
        static let assistant = "Assistant"
        static let profile = "Profile"
    }
    
    // MARK: - System Images
    struct SystemImages {
        // Tab Bar Icons
        static let challengeTab = "target"
        static let assistantTab = "message"
        static let profileTab = "person.circle"
        
        // Challenge Related
        static let eye = "eye.fill"
        static let eyeSlash = "eye.slash.fill"
        static let checkmark = "checkmark.circle.fill"
        static let trophy = "trophy.fill"
        static let clock = "clock.fill"
        static let gauge = "gauge"
        static let timer = "timer"
        
        // Action Buttons
        static let share = "square.and.arrow.up"
        static let refresh = "arrow.clockwise"
        static let clear = "trash"
        static let send = "paperplane.fill"
        static let edit = "pencil"
        static let save = "checkmark"
        static let cancel = "xmark"
        static let next = "chevron.right"
        static let back = "chevron.left"
        static let done = "checkmark.circle"
        static let skip = "forward"
        
        // Chat Related
        static let userAvatar = "person.circle.fill"
        static let assistantAvatar = "brain.head.profile"
        static let robot = "robot"
        static let typingDots = "ellipsis"
        
        // Profile Related
        static let star = "star.circle.fill"
        static let chart = "chart.bar.fill"
        static let settings = "gearshape.fill"
        static let heart = "heart.fill"
        static let bell = "bell.fill"
        static let question = "questionmark.circle"
        static let info = "info.circle"
        static let contact = "envelope"
        static let faq = "questionmark.bubble"
        
        // Onboarding Related
        static let welcomeIcon = "star.circle.fill"
        
        // Interest Icons
        static let fitness = "figure.run"
        static let creativity = "paintbrush.fill"
        static let mindfulness = "brain.head.profile"
        static let learning = "book.fill"
        static let social = "person.2.fill"
        
        // Status Icons
        static let success = "checkmark.circle.fill"
        static let error = "exclamationmark.circle.fill"
        static let warning = "exclamationmark.triangle.fill"
        static let infoCircle = "info.circle.fill"
        
        // Navigation
        static let chevronRight = "chevron.right"
        static let chevronLeft = "chevron.left"
        static let chevronUp = "chevron.up"
        static let chevronDown = "chevron.down"
        
        // Common UI
        static let plus = "plus"
        static let minus = "minus"
        static let close = "xmark"
        static let search = "magnifyingglass"
        static let filter = "line.3.horizontal.decrease.circle"
        static let sort = "arrow.up.arrow.down"
    }
    
    // MARK: - Button Labels
    struct Button {
        static let reveal = "Reveal Challenge"
        static let accept = "Accept Challenge"
        static let complete = "Complete Challenge"
        static let refresh = "Refresh"
        static let clear = "Clear"
        static let send = "Send"
        static let share = "Share"
        static let edit = "Edit"
        static let save = "Save"
        static let cancel = "Cancel"
        static let next = "Next"
        static let back = "Back"
        static let done = "Done"
        static let skip = "Skip"
    }
    
    // MARK: - Placeholder Text
    struct Placeholder {
        static let typeSomething = "Type Something"
        static let searchChallenges = "Search challenges..."
        static let enterName = "Enter your name"
        static let enterEmail = "Enter your email"
    }
    
    // MARK: - Chat Messages
    struct Chat {
        static let welcomeTitle = "Hello! I'm your Challenge Assistant 🤖"
        static let welcomeMessage = "Ask me anything about today's challenge, get motivation, or share your progress!"
        static let typingIndicator = "Assistant is typing..."
        static let messageSent = "Message sent"
        static let messageError = "Failed to send message"
        static let quickQuestions = "Quick Questions"
    }
    
    // MARK: - Challenge Messages
    struct Challenge {
        static let noChallengeAvailable = "No challenge available for today"
        static let challengeCompleted = "Challenge completed!"
        static let challengeExpired = "Challenge expired"
        static let challengeInProgress = "Challenge in progress"
        static let timeRemaining = "Time"
        static let estimatedTime = "Estimated time"
        static let difficulty = "Difficulty"
        static let category = "Category"
        static let challengeHidden = "Challenge Hidden"
        static let tapToReveal = "Tap 'Reveal Challenge' to see today's task"
        static let loadingChallenge = "Loading your challenge..."
    }
    
    // MARK: - Profile Messages
    struct Profile {
        static let challengeChampion = "Challenge Champion"
        static let level = "Level"
        static let interests = "Interests"
        static let totalCompleted = "Total Completed"
        static let currentStreak = "Current Streak"
        static let longestStreak = "Longest Streak"
        static let achievements = "Achievements"
        static let recentActivity = "Recent Activity"
        static let settings = "Settings"
        static let preferences = "Preferences"
        static let helpSupport = "Help & Support"
        static let about = "About"
    }
    
    // MARK: - Onboarding Messages
    struct Onboarding {
        static let welcomeTitle = "Welcome to Challengely ✨"
        static let welcomeSubtitle = "Your daily companion for personal growth and meaningful challenges"
        static let interestsTitle = "What excites you? 🎯"
        static let interestsSubtitle = "Tap what excites you to get personalized challenges"
        static let difficultyTitle = "Choose your pace 🚀"
        static let difficultySubtitle = "We'll tailor challenges to match your comfort zone"
        static let getStarted = "Let's get started!"
        static let selectInterests = "Please select at least one interest"
        static let selectDifficulty = "Please select a difficulty level"
    }
    
    // MARK: - Error Messages
    struct Error {
        static let general = "Something went wrong"
        static let network = "Network connection error"
        static let invalidInput = "Invalid input"
        static let emptyMessage = "Message cannot be empty"
        static let characterLimit = "Message too long"
        static let duplicateMessage = "Duplicate message"
        static let saveFailed = "Failed to save data"
        static let loadFailed = "Failed to load data"
    }
    
    // MARK: - Success Messages
    struct Success {
        static let challengeCompleted = "Great job! Challenge completed!"
        static let profileUpdated = "Profile updated successfully"
        static let messageSent = "Message sent successfully"
        static let dataSaved = "Data saved successfully"
    }
    
    // MARK: - Time Formats
    struct Time {
        static let minutes = "minutes"
        static let seconds = "seconds"
        static let hours = "hours"
        static let days = "days"
        static let weeks = "weeks"
    }
    
    // MARK: - Character Limits
    struct Limits {
        static let messageLength = 500
        static let nameLength = 50
        static let descriptionLength = 200
    }
    
    // MARK: - Animation Durations
    struct Animation {
        static let short = 0.2
        static let medium = 0.5
        static let long = 1.0
        static let splash = 3.5
    }
    
    // MARK: - UserDefaults Keys
    struct UserDefaults {
        static let userProfile = "userProfile"
        static let currentChallenge = "currentChallenge"
        static let chatMessages = "chatMessages"
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let lastAppLaunch = "lastAppLaunch"
    }
} 

/// Centralized color constants for the app
struct AppColor {
    // Primary Colors
    static let appPrimary = Color("AppPrimaryColor")
    static let accent = Color("Accent")
    static let primaryDark = Color("PrimaryDark")
    
    // Background Colors
    static let background = Color("Background")
    static let card = Color("Card")
    
    // Text Colors
    static let textLabel = Color("TextLabel")
    static let subtext = Color("Subtext")
    
    // Status Colors
    static let success = Color("Success")
    static let challengeRed = Color("ChallengeRed")
    
    // UI Element Colors
    static let divider = Color("Divider")
    static let confettiYellow = Color("ConfettiYellow")
    static let typingDots = Color("TypingDots")
    
    // Chat Bubble Colors
    static let aiBubble = Color("AIBubble")
    static let userBubble = Color("UserBubble")
}
