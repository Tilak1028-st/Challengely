//
//  CategoryCard.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct CategoryCard: View {
    let interest: UserProfile.Interest
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: interest.icon)
                .font(.title2)
                .foregroundColor(Color(interest.color))
            
            Text(interest.rawValue)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(Color("TextLabel"))
            
            Text("3 completed")
                .font(.caption2)
                .foregroundColor(Color("Subtext"))
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("Card").opacity(0.5))
        )
    }
}
