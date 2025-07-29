//
//  PreferencesView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct PreferencesView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    @State private var selectedTheme = "System"
    @State private var enableHaptics = true
    @State private var enableAnimations = true
    @State private var challengeFrequency = "Daily"
    
    private let themes = ["System", "Light", "Dark"]
    private let frequencies = ["Daily", "Every Other Day", "Weekly"]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Theme Selection
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Appearance")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextLabel"))
                        
                        VStack(spacing: 12) {
                            ForEach(themes, id: \.self) { theme in
                                PreferenceRow(
                                    title: theme,
                                    subtitle: theme == "System" ? "Follow system settings" : "Use \(theme.lowercased()) mode",
                                    isSelected: selectedTheme == theme,
                                    action: { selectedTheme = theme }
                                )
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Card"))
                    )
                    
                    // Challenge Preferences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Challenge Preferences")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextLabel"))
                        
                        VStack(spacing: 12) {
                            ForEach(frequencies, id: \.self) { frequency in
                                PreferenceRow(
                                    title: frequency,
                                    subtitle: "Receive challenges \(frequency.lowercased())",
                                    isSelected: challengeFrequency == frequency,
                                    action: { challengeFrequency = frequency }
                                )
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Card"))
                    )
                    
                    // Interaction Preferences
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Interaction")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextLabel"))
                        
                        VStack(spacing: 12) {
                            ToggleRow(
                                title: "Haptic Feedback",
                                subtitle: "Feel vibrations when interacting",
                                isOn: $enableHaptics
                            )
                            
                            ToggleRow(
                                title: "Animations",
                                subtitle: "Show smooth transitions",
                                isOn: $enableAnimations
                            )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Card"))
                    )
                }
                .padding(20)
            }
            .navigationTitle("Preferences")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}
