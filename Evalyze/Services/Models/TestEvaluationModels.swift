//
//  TestEvaluationModels.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

// MARK: - Test Evaluation Models
struct TestEvaluationRequest: Codable {
    let test: TestEvaluationData
    let studentAnswers: [QuestionAnswer]
}

struct TestEvaluationData: Codable {
    let title: String
    let description: String
    let questions: [QuestionData]
}

struct QuestionData: Codable {
    let id: Int
    let title: String
    let prompt: String
}

struct QuestionAnswer: Codable {
    let questionId: Int
    let answer: String
}

// MARK: - Response Models
struct TestEvaluationResponse: Codable {
    let overallScore: Double
    let questionScores: [QuestionScore]
    let feedback: String
    
    enum CodingKeys: String, CodingKey {
        case overallScore = "overall_score"
        case questionScores = "question_scores"
        case feedback = "feedback"
    }
}

struct QuestionScore: Codable {
    let questionId: Int
    let score: Double
    let feedback: String
    
    enum CodingKeys: String, CodingKey {
        case questionId = "question_id"
        case score = "score"
        case feedback = "feedback"
    }
}
