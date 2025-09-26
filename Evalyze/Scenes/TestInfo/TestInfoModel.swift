//
//  TestInfoModel.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

// MARK: - Data Structures
struct TestSession {
    let id: String
    let testId: String
    let testTitle: String
    let startTime: Date
    let duration: TimeInterval
    let status: TestStatus
    let studentIds: [String]
}

struct StudentStatus {
    let student: Student
    let joined: Bool
    let startTime: Date?
    let progress: Double
    let currentQuestion: Int
    let totalQuestions: Int
}

struct StudentStatusDisplay {
    let id: String
    let name: String
    let group: String
    let status: String
    let statusColor: UIColor
    let progress: String
    let progressPercentage: Double
    let timeSpent: String
}

enum TestStatus {
    case active, finished, cancelled
    
    var displayName: String {
        switch self {
        case .active: return "Активен"
        case .finished: return "Завершен"
        case .cancelled: return "Отменен"
        }
    }
}

// MARK: - Clean Swift Models
enum TestInfoModel {
    enum Load {
        struct Request { }
        struct Response {
            let testSession: TestSession
            let studentStatuses: [StudentStatus]
            let error: Error?
        }
        struct ViewModel {
            let testTitle: String
            let timeRemaining: String
            let students: [StudentStatusDisplay]
            let totalStudents: String
            let joinedStudents: String
            let progress: String
            let errorMessage: String?
        }
    }
    
    enum Update {
        struct Request { }
        struct Response {
            let studentStatuses: [StudentStatus]
            let timeRemaining: TimeInterval
            let error: Error?
        }
        struct ViewModel {
            let students: [StudentStatusDisplay]
            let joinedStudents: String
            let timeRemaining: String
            let progress: String
            let errorMessage: String?
        }
    }
    
    enum CloseTest {
        struct Request { }
        struct Response {
            let success: Bool
            let error: Error?
        }
        struct ViewModel {
            let success: Bool
            let errorMessage: String?
        }
    }
}
