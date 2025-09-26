//
//  NonSelectableTextView.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 26.09.2025.
//

import UIKit

final class NonSelectableTextView: UITextView {
    override var canBecomeFirstResponder: Bool { true } // ввод разрешён
    override var selectedTextRange: UITextRange? {
        get { nil } // не даём выделять
        set { }     // игнорируем попытку выделения
    }
    
    // Отключаем контекстное меню (копировать/вырезать/вставить)
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}
