//
//  TestResult.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import Foundation

struct TestResult {
    let answers: [Int: String]
    let overallScore: Double?
    let questionScores: [QuestionScore]?
    let feedback: String?
    
    init(answers: [Int: String], overallScore: Double? = nil, questionScores: [QuestionScore]? = nil, feedback: String? = nil) {
        self.answers = answers
        self.overallScore = overallScore
        self.questionScores = questionScores
        self.feedback = feedback
    }
}
