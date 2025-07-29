//
//  PreferenceRow.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct PreferenceRow: View {
    let title: String
    let subtitle: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundColor(Color("TextLabel"))
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Color("Subtext"))
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(Color("AppPrimaryColor"))
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color("AppPrimaryColor").opacity(0.1) : Color("Card").opacity(0.5))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
