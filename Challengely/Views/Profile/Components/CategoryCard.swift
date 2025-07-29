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
                .foregroundColor(AppColor.textLabel)
            
            Text("3 completed")
                .font(.caption2)
                .foregroundColor(AppColor.subtext)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.card.opacity(0.5))
        )
    }
}
