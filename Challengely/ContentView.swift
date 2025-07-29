//
//  ContentView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    @State private var showSplash = true
    
    let obj = Observed()

    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView {
                    withAnimation(.easeInOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            } else {
                if dataManager.userProfile.hasCompletedOnboarding {
                    MainTabView()
                        .environmentObject(dataManager)
                        .environmentObject(obj)
                        .transition(.opacity.combined(with: .scale))
                } else {
                    OnboardingView()
                        .environmentObject(dataManager)
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
        .animation(.easeInOut(duration: 0.5), value: showSplash)
    }
}

#Preview {
    ContentView()
}
