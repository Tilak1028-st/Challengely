//
//  MainTabView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

/// MainTabView serves as the primary navigation container for the Challengely app
struct MainTabView: View {
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ChallengeView()
                .tabItem {
                    Image(systemName: Constants.SystemImages.challengeTab)
                    Text(Constants.Tab.challenge)
                }
                .tag(0)
            
            ChatView()
                .tabItem {
                    Image(systemName: Constants.SystemImages.assistantTab)
                    Text(Constants.Tab.assistant)
                }
                .tag(1)
            
            ProfileView()
                .tabItem {
                    Image(systemName: Constants.SystemImages.profileTab)
                    Text(Constants.Tab.profile)
                }
                .tag(2)
        }
        .accentColor(AppColor.appPrimary)
        .onChange(of: selectedTab) { _, newValue in
            HapticManager.shared.impact(style: .light)
        }
        .onAppear {
            // Configure tab bar appearance for consistent styling
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = UIColor.systemBackground
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
} 
 
