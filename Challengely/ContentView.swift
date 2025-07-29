//
//  ContentView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var dataManager = DataManager()
    
    let obj = Observed()

    var body: some View {
        if dataManager.userProfile.hasCompletedOnboarding {
            MainTabView()
                .environmentObject(dataManager)
                .environmentObject(obj)
        } else {
            OnboardingView()
                .environmentObject(dataManager)
        }
    }
}

#Preview {
    ContentView()
}
