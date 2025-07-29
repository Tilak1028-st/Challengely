//
//  ProgressInsightsView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct ProgressInsightsView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Weekly Progress Chart
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Weekly Progress")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextLabel"))
                        
                        WeeklyProgressChart()
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Card"))
                    )
                    
                    // Challenge Categories
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Challenge Categories")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextLabel"))
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(dataManager.userProfile.interests, id: \.self) { interest in
                                CategoryCard(interest: interest)
                            }
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Card"))
                    )
                    
                    // Performance Stats
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Performance Insights")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextLabel"))
                        
                        VStack(spacing: 12) {
                            InsightRow(
                                title: "Best Day",
                                value: "Wednesday",
                                icon: "calendar.circle.fill",
                                color: Color("Success")
                            )
                            
                            InsightRow(
                                title: "Average Completion Time",
                                value: "15 minutes",
                                icon: "clock.fill",
                                color: Color("Accent")
                            )
                            
                            InsightRow(
                                title: "Most Challenging Category",
                                value: "Mindfulness",
                                icon: "brain.head.profile",
                                color: Color("AppPrimaryColor")
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
            .navigationTitle("Progress Insights")
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
