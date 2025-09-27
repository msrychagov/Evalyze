//
//  TestResultsInteractor.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

final class TestResultsInteractor: TestResultsInteractorInputProtocol {
    weak var presenter: TestResultsInteractorOutputProtocol?
    
    // Mock пользователь - можно изменить на .student для тестирования
    private let currentUser: User = User(
        id: "mock_user_id",
        email: "mikhail@example.com",
        fullName: "Михаил Рычагов",
        role: .teacher, // Измените на .student для тестирования режима студента
        groups: ["БПИНЖ2383"],
        createdAt: Date()
    )
    
    private var studentResult: StudentTestResult?
    
    func fetchTestResults(for testId: String) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Mock data - in real app this would come from API
            let mockTest = Test.mockCompletedTests.first { $0.id == testId }
            guard let test = mockTest else {
                self.presenter?.didFailToFetchResults(NSError(domain: "TestNotFound", code: 404, userInfo: nil))
                return
            }
            
            let results = QuestionResult.mockResults(for: test)
            self.presenter?.didFetchTestResults(results)
        }
    }
    
    func fetchStudentTestResults(for studentResult: StudentTestResult) {
        self.studentResult = studentResult
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Возвращаем результаты конкретного студента
            self.presenter?.didFetchTestResults(studentResult.questionResults)
        }
    }
    
    func updateQuestionScore(questionId: Int, score: Int) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // Mock success - in real app this would update server
            self.presenter?.didUpdateScoreSuccessfully()
        }
    }
    
    func getCurrentUserRole() -> UserRole {
        return currentUser.role
    }
}
