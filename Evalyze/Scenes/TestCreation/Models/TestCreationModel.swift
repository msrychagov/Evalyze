//
//  TestCreationModel.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

struct TestCreationModel {
    var title: String
    var description: String
    var selectedGroup: String?
    var selectedQuestions: [Question]
    var duration: TimeInterval // в секундах
    var startDate: Date?
    
    init() {
        self.title = ""
        self.description = ""
        self.selectedGroup = nil
        self.selectedQuestions = []
        self.duration = 3600 // 1 час по умолчанию
        self.startDate = nil
    }
    
    var isValid: Bool {
        return !title.isEmpty && 
               !description.isEmpty && 
               selectedGroup != nil && 
               !selectedQuestions.isEmpty
    }
}

// MARK: - Mock Data
extension TestCreationModel {
    static let mockGroups = [
        "БПИНЖ2383",
        "БПИНЖ2384", 
        "БПИНЖ2385",
        "БПИНЖ2386"
    ]
    
    static let mockQuestions = [
        Question(
            id: 1,
            title: "Алгоритмы",
            prompt: "Что такое алгоритм?",
            answer: nil
        ),
        Question(
            id: 2,
            title: "Структуры данных",
            prompt: "Какие основные структуры данных вы знаете?",
            answer: nil
        ),
        Question(
            id: 3,
            title: "Рекурсия",
            prompt: "Что такое рекурсия?",
            answer: nil
        ),
        Question(
            id: 4,
            title: "Стек",
            prompt: "Какой принцип работы у стека?",
            answer: nil
        ),
        Question(
            id: 5,
            title: "Сложность алгоритма",
            prompt: "Что такое сложность алгоритма?",
            answer: nil
        ),
        Question(
            id: 6,
            title: "Сортировка",
            prompt: "Какие типы сортировки вы знаете?",
            answer: nil
        ),
        Question(
            id: 7,
            title: "Хеш-таблица",
            prompt: "Что такое хеш-таблица?",
            answer: nil
        ),
        Question(
            id: 8,
            title: "Бинарный поиск",
            prompt: "Как работает бинарный поиск?",
            answer: nil
        )
    ]
}
