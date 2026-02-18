//
//  TestResultsInteractor.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

final class TestResultsInteractor: TestResultsInteractorInputProtocol {
    weak var presenter: TestResultsInteractorOutputProtocol?
    
    // Реальный пользователь из системы
    private var currentUser: User? {
        return UserManager.shared.getCurrentUser()
    }
    
    private var studentResult: StudentTestResult?
    private let answerService: StudentTestAnswerServiceProtocol
    
    init() {
        self.answerService = StudentTestAnswerService()
    }
    
    func fetchTestResults(for testId: String) {
        print("📊 Fetching test results for testId: \(testId)")
        
        guard let currentUser = currentUser else {
            presenter?.didFailToFetchResults(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Пользователь не авторизован"]))
            return
        }
        
        // Загружаем ответы студента из Firebase
        answerService.getStudentAnswers(for: testId, studentId: currentUser.id) { [weak self] result in
            switch result {
            case .success(let studentAnswer):
                // Загружаем тест чтобы получить вопросы
                TestService().getAllTests { testResult in
                    switch testResult {
                    case .success(let tests):
                        if let test = tests.first(where: { $0.id == testId }) {
                            // Преобразуем ответы студента в QuestionResult
                            let questionResults = studentAnswer.questionScores.compactMap { questionScore -> QuestionResult? in
                                let answer = studentAnswer.answers[String(questionScore.questionId)] ?? "Ответ не предоставлен"
                                
                                // Находим соответствующий вопрос в тесте
                                if let questionIndex = test.questions.firstIndex(where: { $0.intId == questionScore.questionId }) {
                                    let question = test.questions[questionIndex]
                                    return QuestionResult(
                                        question: question,
                                        studentAnswer: answer,
                                        correctAnswer: "Правильный ответ не определен", // В будущем можно добавить правильные ответы
                                        score: Int(questionScore.score),
                                        maxScore: 10
                                    )
                                }
                                return nil
                            }
                            
                            self?.presenter?.didFetchTestResults(questionResults)
                        } else {
                            self?.presenter?.didFailToFetchResults(NSError(domain: "NotFound", code: 404, userInfo: [NSLocalizedDescriptionKey: "Тест не найден"]))
                        }
                    case .failure(let error):
                        self?.presenter?.didFailToFetchResults(error)
                    }
                }
            case .failure(let error):
                print("❌ Failed to fetch student answers: \(error.localizedDescription)")
                self?.presenter?.didFailToFetchResults(error)
            }
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
        return currentUser?.role ?? .student
    }
}
