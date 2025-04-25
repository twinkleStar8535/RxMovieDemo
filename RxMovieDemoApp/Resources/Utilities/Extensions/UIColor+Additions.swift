//
//  UIColor+Additions.swift
//  RxMovieDemoApp
//
//  Created by YcLin on 2025/2/23.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
            hexSanitized = hexSanitized.replacingOccurrences(of: "0X", with: "")

        var rgb: UInt64 = 0

        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        let red = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
        let blue = CGFloat(rgb & 0x0000FF) / 255.0

        self.init(red: red, green: green, blue: blue, alpha: 1.0)
    }

    convenience init(hex: String, a: CGFloat) {
        self.init(hex: hex)
        let modifiedColor = self.withAlphaComponent(a)
        self.init(cgColor: modifiedColor.cgColor)
    }

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }

    convenience init(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: a)
    }
}
