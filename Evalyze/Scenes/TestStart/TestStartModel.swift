//
//  TestStartModel.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

// MARK: - Data Structures
struct Test {
    let id: String
    let title: String
    let duration: Int
    let questionCount: Int
    let questions: [Question]
}

struct Student {
    let id: String
    let name: String
    let group: String
    let email: String
}

enum QuestionType {
    case openEnded
    case multipleChoice
}

struct TestDisplay {
    let id: String
    let title: String
    let duration: String
    let questionCount: String
    let isSelected: Bool
}

struct StudentDisplay {
    let id: String
    let name: String
    let group: String
    let isSelected: Bool
}

// MARK: - Clean Swift Models
enum TestStartModel {
    enum Start {
        struct Request { }
        struct Response {
            let availableTests: [Test]
            let availableStudents: [Student]
            let selectedTestId: String?
            let selectedStudentIds: [String]
        }
        struct ViewModel {
            let tests: [TestDisplay]
            let students: [StudentDisplay]
            let isStartButtonEnabled: Bool
            let errorMessage: String?
        }
    }
    
    enum LoadTests {
        struct Request { }
        struct Response {
            let tests: [Test]
            let error: Error?
        }
        struct ViewModel {
            let tests: [TestDisplay]
            let errorMessage: String?
        }
    }
    
    enum LoadStudents {
        struct Request { }
        struct Response {
            let students: [Student]
            let error: Error?
        }
        struct ViewModel {
            let students: [StudentDisplay]
            let errorMessage: String?
        }
    }
    
    enum SelectTest {
        struct Request {
            let testId: String
        }
        struct Response {
            let selectedTestId: String?
            let students: [Student]
            let error: Error?
        }
        struct ViewModel {
            let selectedTestId: String?
            let students: [StudentDisplay]
            let isStartButtonEnabled: Bool
            let errorMessage: String?
        }
    }
    
    enum ToggleStudent {
        struct Request {
            let studentId: String
        }
        struct Response {
            let selectedStudentIds: [String]
            let students: [Student]
            let selectedTestId: String?
            let error: Error?
        }
        struct ViewModel {
            let students: [StudentDisplay]
            let isStartButtonEnabled: Bool
            let errorMessage: String?
        }
    }
    
    enum StartTest {
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
