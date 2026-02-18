//
//  StudentTestAnswer.swift
//  Evalyze
//
//  Created by Assistant on 27.09.2025.
//

import Foundation

struct StudentTestAnswer: Codable {
    let id: String
    let testId: String
    let studentId: String
    let answers: [String: String] // questionId: answer
    let overallScore: Double
    let questionScores: [QuestionScore]
    let feedback: String
    let completedAt: Date
    
    init(testId: String, studentId: String, answers: [String: String], overallScore: Double, questionScores: [QuestionScore], feedback: String) {
        self.id = UUID().uuidString
        self.testId = testId
        self.studentId = studentId
        self.answers = answers
        self.overallScore = overallScore
        self.questionScores = questionScores
        self.feedback = feedback
        self.completedAt = Date()
    }
}
