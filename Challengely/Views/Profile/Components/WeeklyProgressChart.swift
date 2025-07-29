//
//  WeeklyProgressChart.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct WeeklyProgressChart: View {
    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            ForEach(0..<7, id: \.self) { day in
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color("AppPrimaryColor").opacity(0.3))
                        .frame(width: 30, height: CGFloat.random(in: 20...80))
                    
                    Text(["M", "T", "W", "T", "F", "S", "S"][day])
                        .font(.caption2)
                        .foregroundColor(Color("Subtext"))
                }
            }
        }
        .frame(height: 100)
    }
}
