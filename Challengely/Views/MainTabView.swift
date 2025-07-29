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
    
    var body: some View {
        TabView {
            ChallengeView()
                .tabItem {
                    Image(systemName: Constants.SystemImages.challengeTab)
                    Text(Constants.Tab.challenge)
                }
            
            ChatView()
                .tabItem {
                    Image(systemName: Constants.SystemImages.assistantTab)
                    Text(Constants.Tab.assistant)
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: Constants.SystemImages.profileTab)
                    Text(Constants.Tab.profile)
                }
        }
        .accentColor(Color("AppPrimaryColor"))
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
 
