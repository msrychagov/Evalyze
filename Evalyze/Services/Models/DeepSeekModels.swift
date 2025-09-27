//
//  DeepSeekModels.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

// MARK: - DeepSeek API Models
struct DeepSeekRequest: Codable {
    let model: String
    let messages: [DeepSeekMessage]
    let temperature: Double
    let maxTokens: Int
    
    enum CodingKeys: String, CodingKey {
        case model = "model"
        case messages = "messages"
        case temperature = "temperature"
        case maxTokens = "max_tokens"
    }
}

struct DeepSeekMessage: Codable, Equatable {
    let role: String
    let content: String
    
    enum CodingKeys: String, CodingKey {
        case role = "role"
        case content = "content"
    }
    
    static func == (lhs: DeepSeekMessage, rhs: DeepSeekMessage) -> Bool {
        return lhs.role == rhs.role && lhs.content == rhs.content
    }
}

struct DeepSeekResponse: Codable, Equatable {
    let choices: [DeepSeekChoice]
    
    enum CodingKeys: String, CodingKey {
        case choices = "choices"
    }
    
    static func == (lhs: DeepSeekResponse, rhs: DeepSeekResponse) -> Bool {
        return lhs.choices == rhs.choices
    }
}

struct DeepSeekChoice: Codable, Equatable {
    let message: DeepSeekMessage
    
    enum CodingKeys: String, CodingKey {
        case message = "message"
    }
    
    static func == (lhs: DeepSeekChoice, rhs: DeepSeekChoice) -> Bool {
        return lhs.message == rhs.message
    }
}
