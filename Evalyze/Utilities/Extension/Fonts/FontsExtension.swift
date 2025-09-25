//
//  FontsExtension.swift
//  Evalyze
//
//  Created by Артём on 20.09.2025.
//

import UIKit

enum CustomFonts: String {
    case sansBold = "HSESans-Bold"
    case sansItalic = "HSESans-Italic"
    case sansRegular = "HSESans-Regular"
    case sansSemiBold = "HSESans-SemiBold"
    case sansThin = "HSESans-Thin"
}

extension UIFont {
    static func custom(_ customFont: CustomFonts, size: CGFloat) -> UIFont {
        return UIFont(name: customFont.rawValue, size: size) ?? UIFont.systemFont(ofSize: size)
    }
}

extension UILabel {
    func setCustomFont(_ customFont: CustomFonts, size: CGFloat) {
        self.font = UIFont.custom(customFont, size: size)
    }
}

extension UIButton {
    func setCustomFont(_ customFont: CustomFonts, size: CGFloat) {
        self.titleLabel?.font = UIFont.custom(customFont, size: size)
    }
}

extension UITextField {
    func setCustomFont(_ customFont: CustomFonts, size: CGFloat) {
        self.font = UIFont.custom(customFont, size: size)
    }
}

extension UITextView {
    func setCustomFont(_ customFont: CustomFonts, size: CGFloat) {
        self.font = UIFont.custom(customFont, size: size)
    }
}
