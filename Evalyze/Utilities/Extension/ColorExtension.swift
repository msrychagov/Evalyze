//
//  ColorExtension.swift
//  Evalyze
//
//  Created by Артём on 20.09.2025.
//

import Foundation
import UIKit

extension UIColor {
    static let blackApp = UIColor.adaptiveColor(lightHex: "#090A0C", darkHex: "#090A0C")
    static let grayApp = UIColor.adaptiveColor(lightHex: "#18191B", darkHex: "#18191B")
    static let lightGrayApp = UIColor.adaptiveColor(lightHex: "#2C2C2E", darkHex: "#2C2C2E")
    static let mainTextApp = UIColor.white
    static let secondaryTextApp = UIColor.white.withAlphaComponent(0.8)
    static let blueAccent = UIColor.adaptiveColor(lightHex: "#007AFF", darkHex: "#007AFF")
    static let greenAccent = UIColor.adaptiveColor(lightHex: "#34C759", darkHex: "#34C759")
    static let redAccent = UIColor.adaptiveColor(lightHex: "#FF3B30", darkHex: "#FF3B30")
    static let orangeAccent = UIColor.adaptiveColor(lightHex: "#FF9500", darkHex: "#FF9500")
    static let yellowAccent = UIColor.adaptiveColor(lightHex: "#FFCC00", darkHex: "#FFCC00")
    static let cardBackgroundApp = UIColor.adaptiveColor(lightHex: "#1C1C1E", darkHex: "#1C1C1E")
    static let borderApp = UIColor.adaptiveColor(lightHex: "#2C2C2E", darkHex: "#2C2C2E")
}

extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let alphaFromHex, red, green, blue: UInt64
        switch hex.count {
        case 3:
            (alphaFromHex, red, green, blue) = (15, int >> 8, int >> 4 & 0xF, int & 0xF)
            self.init(red: CGFloat(red) / 15.0, green: CGFloat(green) / 15.0, blue: CGFloat(blue) / 15.0, alpha: alpha)
        case 6:
            (alphaFromHex, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            self.init(
                red: CGFloat(red) / 255.0,
                green: CGFloat(green) / 255.0,
                blue: CGFloat(blue) / 255.0,
                alpha: CGFloat(alphaFromHex)
            )
        default:
            self.init(red: 0, green: 0, blue: 0, alpha: alpha)
        }
    }
    
    static func adaptiveColor(lightHex: String, darkHex: String) -> UIColor {
        return UIColor { traitCollection -> UIColor in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return UIColor(hex: darkHex)
            default:
                return UIColor(hex: lightHex)
            }
        }
    }
}
