//
//  ContentView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

/// ContentView serves as the root view controller for the Challengely app
/// It manages the app's main flow: Splash Screen → Onboarding → Main App
/// This view handles all major state transitions and view routing
struct ContentView: View {
    // MARK: - State Management
    
    /// Central data manager instance that handles all app data and persistence
    /// This is the single source of truth for the entire application
    @StateObject private var dataManager = DataManager()
    
    /// Controls whether to show the splash screen on app launch
    /// Set to true initially, transitions to false after splash animation completes
    @State private var showSplash = true
    
    /// Shared UI state object for dynamic UI element sizing (primarily used by MultiTextField)
    /// This allows components to communicate their size requirements across the app
    let obj = Observed()

    var body: some View {
        ZStack {
            // MARK: - App Flow Logic
            
            if showSplash {
                // MARK: - Splash Screen Phase
                
                /// Display engaging splash screen with animations and branding
                /// This provides a polished first impression and loading experience
                SplashScreenView {
                    /// Callback executed when splash screen animation completes
                    /// Triggers smooth transition to the main app flow
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            } else {
                // MARK: - Main App Phase
                
                if dataManager.userProfile.hasCompletedOnboarding {
                    // MARK: - Main App Interface
                    
                    /// Display the main tab-based interface for users who have completed onboarding
                    /// This is the primary app experience with Challenge, Assistant, and Profile tabs
                    MainTabView()
                        .environmentObject(dataManager)
                        .environmentObject(obj)
                        /// Smooth transition animation combining opacity and scale effects
                        .transition(.opacity.combined(with: .scale))
                } else {
                    // MARK: - Onboarding Flow
                    
                    /// Display onboarding interface for new users
                    /// Guides users through interest selection and difficulty preferences
                    OnboardingView()
                        .environmentObject(dataManager)
                        /// Smooth transition animation for onboarding entrance
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        /// Global animation configuration for state changes
        /// Ensures consistent, smooth transitions throughout the app
        .animation(.easeInOut(duration: 0.5), value: showSplash)
    }
}

#Preview {
    ContentView()
}
