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
                        Image(systemName: Constants.SystemImages.eye)
                            .font(.title3)
                        Text(Constants.Button.reveal)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColor.appPrimary)
                    )
                    .shadow(color: AppColor.appPrimary.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            } else if !isAccepted {
                Button(action: onAccept) {
                    HStack {
                        Image(systemName: Constants.SystemImages.checkmark)
                            .font(.title3)
                        Text(Constants.Button.accept)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColor.accent)
                    )
                    .shadow(color: AppColor.accent.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            } else {
                Button(action: onComplete) {
                    HStack {
                        Image(systemName: Constants.SystemImages.trophy)
                            .font(.title3)
                        Text(Constants.Button.complete)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(AppColor.success)
                    )
                    .shadow(color: AppColor.success.opacity(0.3), radius: 8, x: 0, y: 4)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}
