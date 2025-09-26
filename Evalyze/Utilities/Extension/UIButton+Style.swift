//
//  UIButton+Style.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

extension UIButton {
    func applyPrimaryStyle(title: String) {
        setTitle(title, for: .normal)
        setTitleColor(.grayApp, for: .normal)
        titleLabel?.font = UIFont.custom(.sansBold, size: 16)
        backgroundColor = .mainTextColor
        layer.cornerRadius = 8
    }
}
