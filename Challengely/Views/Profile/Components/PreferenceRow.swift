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
                        .foregroundColor(AppColor.textLabel)
                    
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(AppColor.subtext)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(AppColor.appPrimary)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? AppColor.appPrimary.opacity(0.1) : AppColor.card.opacity(0.5))
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}
