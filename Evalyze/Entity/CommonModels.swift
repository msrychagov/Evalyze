//
//  CommonModels.swift
//  Evalyze
//
//  Created by Assistant on 27.09.2025.
//

import Foundation

// MARK: - Common Models

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
