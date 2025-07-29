//
//  ActionButtonsView.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import SwiftUI

struct ActionButtonsView: View {
    let isRevealed: Bool
    let isAccepted: Bool
    let onReveal: () -> Void
    let onAccept: () -> Void
    let onComplete: () -> Void
    
    var body: some View {
        VStack(spacing: 15) {
            if !isRevealed {
                Button(action: onReveal) {
                    HStack {
                        Image(systemName: "eye.fill")
                            .font(.title3)
                        Text("Reveal Challenge")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("AppPrimaryColor"))
                    )
                    .shadow(color: Color("AppPrimaryColor").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            } else if !isAccepted {
                Button(action: onAccept) {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.title3)
                        Text("Accept Challenge")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Accent"))
                    )
                    .shadow(color: Color("Accent").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: onComplete) {
                    HStack {
                        Image(systemName: "trophy.fill")
                            .font(.title3)
                        Text("Complete Challenge")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("Success"))
                    )
                    .shadow(color: Color("Success").opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
