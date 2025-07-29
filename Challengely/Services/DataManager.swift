//
//  DataManager.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import Foundation
import SwiftUI

/// Central data manager that handles all app state and persistence
/// Single source of truth for user profile, challenges, and chat messages
class DataManager: ObservableObject {
    @Published var userProfile: UserProfile
    @Published var currentChallenge: Challenge?
    @Published var chatMessages: [ChatMessage] = []
    
    private let userDefaults = UserDefaults.standard
    private let userProfileKey = Constants.UserDefaults.userProfile
    private let currentChallengeKey = Constants.UserDefaults.currentChallenge
    private let chatMessagesKey = Constants.UserDefaults.chatMessages
    
    init() {
        // Load user profile from UserDefaults
        if let data = userDefaults.data(forKey: userProfileKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = profile
        } else {
            self.userProfile = UserProfile()
        }
        
        // Load current challenge from UserDefaults
        if let data = userDefaults.data(forKey: currentChallengeKey),
           let challenge = try? JSONDecoder().decode(Challenge.self, from: data) {
            self.currentChallenge = challenge
        }
        
        // Load chat messages from UserDefaults
        if let data = userDefaults.data(forKey: chatMessagesKey),
           let messages = try? JSONDecoder().decode([ChatMessage].self, from: data) {
            self.chatMessages = messages
        }
        
        // Generate new challenge if needed (new day or no challenge)
        if currentChallenge == nil || !Calendar.current.isDate(currentChallenge!.date, inSameDayAs: Date()) {
            generateNewChallenge()
        }
    }
    
    // MARK: - Persistence Methods
    
    func saveUserProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            userDefaults.set(data, forKey: userProfileKey)
        }
    }
    
    func saveCurrentChallenge() {
        if let challenge = currentChallenge,
           let data = try? JSONEncoder().encode(challenge) {
            userDefaults.set(data, forKey: currentChallengeKey)
        }
    }
    
    func saveChatMessages() {
        if let data = try? JSONEncoder().encode(chatMessages) {
            userDefaults.set(data, forKey: chatMessagesKey)
        }
    }
    
    // MARK: - Challenge Management
    
    func generateNewChallenge() {
        let challenges = Challenge.sampleChallenges
        let randomIndex = Int.random(in: 0..<challenges.count)
        currentChallenge = challenges[randomIndex]
        saveCurrentChallenge()
        
        // Clear chat messages for new challenge
        chatMessages = []
        saveChatMessages()
    }
    
    func completeChallenge() {
        guard var challenge = currentChallenge else { return }
        challenge.isCompleted = true
        challenge.completionTime = Date()
        currentChallenge = challenge
        saveCurrentChallenge()
        
        // Update user stats
        userProfile.totalChallengesCompleted += 1
        
        // Update streak logic
        if let lastDate = userProfile.lastChallengeDate {
            let calendar = Calendar.current
            if calendar.isDate(lastDate, inSameDayAs: Date().addingTimeInterval(-86400)) {
                userProfile.currentStreak += 1
            } else if !calendar.isDate(lastDate, inSameDayAs: Date()) {
                userProfile.currentStreak = 1
            }
        } else {
            userProfile.currentStreak = 1
        }
        
        userProfile.longestStreak = max(userProfile.currentStreak, userProfile.longestStreak)
        userProfile.lastChallengeDate = Date()
        
        saveUserProfile()
    }
    
    // MARK: - Chat Management
    
    func addChatMessage(_ message: ChatMessage) {
        chatMessages.append(message)
        saveChatMessages()
    }
    
    func clearChatMessages() {
        chatMessages = []
        saveChatMessages()
    }
    
    func updateLastMessage(_ message: ChatMessage) {
        if !chatMessages.isEmpty {
            chatMessages[chatMessages.count - 1] = message
            saveChatMessages()
        }
    }
} 