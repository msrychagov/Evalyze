//
//  Test.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

enum TestStatus: String, CaseIterable {
    case upcoming = "upcoming"
    case completed = "completed"
}

struct Test {
    let id: String
    let title: String
    let description: String
    let questions: [Question]
    let duration: TimeInterval // в секундах
    let status: TestStatus
    let createdAt: Date
    let createdBy: String // ID преподавателя, создавшего тест
    let targetGroup: String // Название группы, для которой предназначен тест
    let dueDate: Date?
    let completedAt: Date?
    let score: Int?
    let maxScore: Int
    
    init(
        id: String,
        title: String,
        description: String,
        questions: [Question],
        duration: TimeInterval,
        status: TestStatus,
        createdBy: String,
        targetGroup: String,
        createdAt: Date = Date(),
        dueDate: Date? = nil,
        completedAt: Date? = nil,
        score: Int? = nil,
        maxScore: Int = 10
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.questions = questions
        self.duration = duration
        self.status = status
        self.createdAt = createdAt
        self.createdBy = createdBy
        self.targetGroup = targetGroup
        self.dueDate = dueDate
        self.completedAt = completedAt
        self.score = score
        self.maxScore = maxScore
    }
}

