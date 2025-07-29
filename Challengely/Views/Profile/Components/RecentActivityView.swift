//
//  RecentActivityView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct RecentActivityView: View {
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Recent Activity")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("TextLabel"))
            
            VStack(spacing: 12) {
                ForEach(0..<min(3, dataManager.chatMessages.count), id: \.self) { index in
                    let message = dataManager.chatMessages[dataManager.chatMessages.count - 1 - index]
                    ActivityRow(
                        icon: message.isFromUser ? "person.circle.fill" : "brain.head.profile",
                        title: message.isFromUser ? "You sent a message" : "Assistant responded",
                        subtitle: message.content.prefix(50) + (message.content.count > 50 ? "..." : ""),
                        time: message.timestamp,
                        color: message.isFromUser ? Color("Accent") : Color("PrimaryColor")
                    )
                }
                
                if dataManager.chatMessages.isEmpty {
                    Text("No recent activity")
                        .font(.caption)
                        .foregroundColor(Color("Subtext"))
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 20)
                }
            }
        }
    }
}
