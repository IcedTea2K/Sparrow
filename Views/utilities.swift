//
//  utilities.swift
//  Sparrow
//
//  Created by Minh Au on 2024-02-23.
//

import Foundation
import SwiftUI

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: String(hex.dropFirst()))
        var res: UInt64 = 0
        
        scanner.currentIndex = scanner.string.startIndex
        scanner.scanHexInt64(&res)
        
        let red = Double((res & 0xFF0000) >> 16) / 255.0
        let green = Double((res & 0x00FF00) >> 8) / 255.0
        let blue = Double(res & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct PersonPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}
