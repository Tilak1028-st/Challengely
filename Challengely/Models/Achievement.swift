//
//  Achievement.swift
//  Challengely
//
//  Created by Tilak Shakya on 29/07/25.
//

import Foundation
import SwiftUI

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isEarned: Bool
}
