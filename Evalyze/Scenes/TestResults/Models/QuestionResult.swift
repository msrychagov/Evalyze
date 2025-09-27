//
//  QuestionResult.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

struct QuestionResult {
    let question: Question
    let studentAnswer: String
    let correctAnswer: String
    let score: Int
    let maxScore: Int
    let isCorrect: Bool
    
    init(question: Question, studentAnswer: String, correctAnswer: String, score: Int, maxScore: Int = 10) {
        self.question = question
        self.studentAnswer = studentAnswer
        self.correctAnswer = correctAnswer
        self.score = score
        self.maxScore = maxScore
        self.isCorrect = score == maxScore
    }
}

