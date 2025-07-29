//
//  HelpSupportView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct HelpSupportView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // FAQ Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Frequently Asked Questions")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextLabel"))
                        
                        VStack(spacing: 12) {
                            FAQRow(
                                question: "How do challenges work?",
                                answer: "Each day, you'll receive a personalized challenge based on your interests and difficulty preference. Complete it to build your streak!"
                            )
                            
                            FAQRow(
                                question: "Can I skip a challenge?",
                                answer: "Yes! You can skip challenges, but it will reset your current streak. Try to complete at least one challenge per day."
                            )
                            
                            FAQRow(
                                question: "How is my streak calculated?",
                                answer: "Your streak increases each day you complete a challenge. Missing a day resets it to zero."
                            )
                            
                            FAQRow(
                                question: "Can I change my interests?",
                                answer: "Yes! Go to Profile > Edit Profile to update your interests and difficulty preferences."
                            )
                        }
                    }
                    .padding(20)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Card"))
                    )
                    
                    // Contact Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Get in Touch")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(Color("TextLabel"))
                        
                        VStack(spacing: 12) {
                            ContactRow(
                                icon: "envelope.fill",
                                title: "Email Support",
                                subtitle: "support@challengely.com",
                                color: Color("PrimaryColor")
                            )
                            
                            ContactRow(
                                icon: "message.fill",
                                title: "Live Chat",
                                subtitle: "Available 24/7",
                                color: Color("Success")
                            )
                            
                            ContactRow(
                                icon: "globe",
                                title: "Website",
                                subtitle: "challengely.com",
                                color: Color("Accent")
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
            .navigationTitle("Help & Support")
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
