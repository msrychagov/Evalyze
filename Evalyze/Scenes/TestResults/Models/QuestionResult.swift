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

// MARK: - Mock Data
extension QuestionResult {
    static func mockResults(for test: Test) -> [QuestionResult] {
        return test.questions.map { question in
            let studentAnswers = [
                "Основные компоненты компьютера включают процессор, оперативную память, жесткий диск, материнскую плату, блок питания и видеокарту.",
                "Компьютер состоит из монитора, клавиатуры и мыши.",
                "Процессор, память, жесткий диск, материнская плата, блок питания, видеокарта, звуковая карта, сетевой адаптер."
            ]
            let correctAnswers = [
                "Основные компоненты компьютера: процессор (CPU), оперативная память (RAM), постоянная память (ROM), материнская плата, блок питания, видеокарта, жесткий диск.",
                "Основные компоненты компьютера: процессор (CPU), оперативная память (RAM), постоянная память (ROM), материнская плата, блок питания, видеокарта, жесткий диск.",
                "Основные компоненты компьютера: процессор (CPU), оперативная память (RAM), постоянная память (ROM), материнская плата, блок питания, видеокарта, жесткий диск."
            ]
            let scores = [8, 3, 9] // Оценки от 0 до 10
            
            let randomIndex = Int.random(in: 0..<studentAnswers.count)
            
            return QuestionResult(
                question: question,
                studentAnswer: studentAnswers[randomIndex],
                correctAnswer: correctAnswers[randomIndex],
                score: scores[randomIndex],
                maxScore: 10
            )
        }
    }
}
