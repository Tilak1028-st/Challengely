//
//  SettingsSectionView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct SettingsSectionView: View {
    @Binding var showingProgressInsights: Bool
    @Binding var showingPreferences: Bool
    @Binding var showingHelpSupport: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("TextLabel"))
            
            VStack(spacing: 8) {
                SettingsRow(
                    icon: "chart.bar.fill",
                    title: "Progress Insights",
                    subtitle: "View detailed analytics",
                    color: Color("Success"),
                    action: { showingProgressInsights = true }
                )
                
                SettingsRow(
                    icon: "gear",
                    title: "Preferences",
                    subtitle: "Customize your experience",
                    color: Color("AppPrimaryColor"),
                    action: { showingPreferences = true }
                )
                
                SettingsRow(
                    icon: "questionmark.circle.fill",
                    title: "Help & Support",
                    subtitle: "Get assistance",
                    color: Color("Subtext"),
                    action: { showingHelpSupport = true }
                )
            }
        }
    }
}
