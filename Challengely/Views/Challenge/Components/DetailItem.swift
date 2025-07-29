//
//  DetailItem.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct DetailItem: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(AppColor.subtext)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(AppColor.textLabel)
        }
    }
}
