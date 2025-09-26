//
//  TestStartAssembly.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

enum TestStartAssembly {
    static func build() -> UIViewController {
        let router = TestStartRouter()
        let presenter = TestStartPresenter()
        
        // Mock services for now - replace with real Firebase services later
        let testService = MockTestService()
        let studentService = MockStudentService()
        let testSessionService = MockTestSessionService()
        
        let interactor = TestStartInteractor(
            presenter: presenter,
            testService: testService,
            studentService: studentService,
            testSessionService: testSessionService
        )
        
        let viewController = TestStartViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}

// MARK: - Mock Services for Development
class MockTestService: TestServiceProtocol {
    func fetchAvailableTests(completion: @escaping (Result<[Test], Error>) -> Void) {
        // Mock data
        let tests = [
            Test(
                id: "1",
                title: "Коллоквиум",
                duration: 60,
                questionCount: 40,
                questions: []
            )
        ]
        completion(.success(tests))
    }
}

class MockStudentService: StudentServiceProtocol {
    func fetchAvailableStudents(completion: @escaping (Result<[Student], Error>) -> Void) {
        // Mock data
        let students = [
            Student(
                id: "1",
                name: "Иван Иванов",
                group: "БПИ238",
                email: "ivan@example.com"
            ),
            Student(
                id: "2",
                name: "Мария Петрова",
                group: "БПИ238",
                email: "maria@example.com"
            ),
            Student(
                id: "3",
                name: "Алексей Сидоров",
                group: "БПИ238",
                email: "alex@example.com"
            )
        ]
        completion(.success(students))
    }
}

class MockTestSessionService: TestSessionServiceProtocol {
    func startTestSession(testId: String, studentIds: [String], completion: @escaping (Result<Void, Error>) -> Void) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            completion(.success(()))
        }
    }
}
