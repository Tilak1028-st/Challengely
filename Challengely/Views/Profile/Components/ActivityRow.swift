//
//  ActivityRow.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct ActivityRow: View {
    let icon: String
    let title: String
    let subtitle: String
    let time: Date
    let color: Color
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(AppColor.textLabel)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(AppColor.subtext)
                    .lineLimit(1)
            }
            
            Spacer()
            
            Text(time, style: .time)
                .font(.caption2)
                .foregroundColor(AppColor.subtext)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(AppColor.card)
        )
    }
}
