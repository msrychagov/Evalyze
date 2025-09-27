//
//  Question.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import Foundation
import FirebaseFirestore

struct Question: Codable, Identifiable, Hashable {
    @DocumentID var id: String?
    let category: String
    let question: String
    let createdAt: Date
    
    // Computed properties для совместимости со старым кодом
    var title: String {
        return category
    }
    
    var prompt: String {
        return question
    }
    
    var answer: String? = nil
    
    // Computed property для совместимости с Int ID
    var intId: Int {
        guard let id = id, let intValue = Int(id) else {
            return abs(hashValue) // Используем hash как fallback
        }
        return intValue
    }
    
    // Инициализатор для совместимости
    init(id: Int, title: String, prompt: String, answer: String? = nil) {
        self.id = String(id)
        self.category = title
        self.question = prompt
        self.createdAt = Date()
        self.answer = answer
    }
    
    // Инициализатор для Firebase
    init(id: String? = nil, category: String, question: String, createdAt: Date = Date()) {
        self.id = id
        self.category = category
        self.question = question
        self.createdAt = createdAt
    }
    
    var dictionary: [String: Any] {
        return [
            "category": category,
            "question": question,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
