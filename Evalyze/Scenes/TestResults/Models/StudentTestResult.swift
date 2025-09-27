//
//  StudentTestResult.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

struct StudentTestResult {
    let student: User
    let test: Test
    let score: Int
    let maxScore: Int
    let completedAt: Date
    let questionResults: [QuestionResult]
    
    var grade: String {
        switch score {
        case 8...10:
            return "Отлично"
        case 6...7:
            return "Хорошо"
        case 4...5:
            return "Удовлетворительно"
        default:
            return "Неудовлетворительно"
        }
    }
}

