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

// MARK: - Mock Data
extension StudentTestResult {
    static func mockResults(for test: Test) -> [StudentTestResult] {
        let mockStudents = [
            User(
                id: "student1",
                email: "anna@example.com",
                fullName: "Анна Иванова",
                role: .student,
                groups: ["БПИНЖ2383"],
                createdAt: Date()
            ),
            User(
                id: "student2",
                email: "petr@example.com",
                fullName: "Петр Петров",
                role: .student,
                groups: ["БПИНЖ2383"],
                createdAt: Date()
            ),
            User(
                id: "student3",
                email: "maria@example.com",
                fullName: "Мария Сидорова",
                role: .student,
                groups: ["БПИНЖ2383"],
                createdAt: Date()
            ),
            User(
                id: "student4",
                email: "alexey@example.com",
                fullName: "Алексей Козлов",
                role: .student,
                groups: ["БПИНЖ2383"],
                createdAt: Date()
            )
        ]
        
        return mockStudents.map { student in
            let questionResults = QuestionResult.mockResults(for: test)
            let totalScore = Int(questionResults.reduce(0) { $0 + $1.score } / questionResults.count)
            let maxScore = 10
            
            return StudentTestResult(
                student: student,
                test: test,
                score: totalScore,
                maxScore: maxScore,
                completedAt: Date().addingTimeInterval(-Double.random(in: 3600...86400)),
                questionResults: questionResults
            )
        }
    }
}
