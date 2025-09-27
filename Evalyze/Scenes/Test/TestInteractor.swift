//
//  TestInteractor.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import Foundation

final class TestInteractor: TestInteractorInputProtocol {
    weak var output: TestInteractorOutputProtocol?
    
    private let testEvaluationService: TestEvaluationServiceProtocol
    private var currentTest: Test?
    
    init(testEvaluationService: TestEvaluationServiceProtocol = TestEvaluationService(networkClient: NetworkClient())) {
        self.testEvaluationService = testEvaluationService
    }

    func fetchIntroInfo() {
        let info = "Тест состоит из 10 вопросов про iOS. Ответы сохраняются автоматически. Удачи!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.output?.didLoadIntro(info)
        }
    }

    func fetchQuestions() {
        let questions = [
            Question(id: 1, title: "ARC", prompt: "Что такое ARC и как он управляет памятью в iOS?"),
            Question(id: 2, title: "Frame vs Bounds", prompt: "Объясните разницу между frame и bounds у UIView и когда что использовать."),
            Question(id: 3, title: "GCD", prompt: "Что такое Grand Central Dispatch? Примеры использования для фоновых задач и UI-обновлений."),
            Question(id: 4, title: "weak vs unowned", prompt: "Чем отличаются weak и unowned ссылки в Swift? Приведите примеры."),
            Question(id: 5, title: "App lifecycle", prompt: "Что происходит в AppDelegate/SceneDelegate при запуске приложения? Основные шаги и точки входа."),
            Question(id: 6, title: "ARC", prompt: "Что такое ARC и как он управляет памятью в iOS?"),
            Question(id: 7, title: "Frame vs Bounds", prompt: "Объясните разницу между frame и bounds у UIView и когда что использовать."),
            Question(id: 8, title: "GCD", prompt: "Что такое Grand Central Dispatch? Примеры использования для фоновых задач и UI-обновлений."),
            Question(id: 9, title: "weak vs unowned", prompt: "Чем отличаются weak и unowned ссылки в Swift? Приведите примеры."),
            Question(id: 10, title: "App lifecycle", prompt: "Что происходит в AppDelegate/SceneDelegate при запуске приложения? Основные шаги и точки входа.")
        ]
        
        // Создаем моковый тест для оценки
        let mockTest = Test(
            id: "mock_test_id",
            title: "iOS Development Test",
            description: "Тест по основам разработки iOS приложений",
            questions: questions,
            duration: 3600,
            status: .upcoming,
            createdAt: Date(),
            dueDate: nil,
            completedAt: nil,
            score: nil,
            maxScore: 100
        )
        
        // Устанавливаем тест для оценки
        setCurrentTest(mockTest)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.output?.didLoadQuestions(questions)
        }
    }

    func submitAnswers(_ answers: [Int : String]) {
        print("🔍 Submitting answers: \(answers)")
        
        guard let test = currentTest else {
            print("❌ No current test found, using fallback")
            // Fallback если нет теста
            let result = TestResult(answers: answers)
            self.output?.didSubmit(result: result)
            return
        }
        
        print("✅ Current test found: \(test.title)")
        
        Task {
            do {
                print("🚀 Sending request to DeepSeek API...")
                let evaluation = try await testEvaluationService.evaluateTest(test: test, studentAnswers: answers)
                print("✅ Received evaluation: \(evaluation)")
                
                // Создаем результат с оценкой
                let result = TestResult(
                    answers: answers,
                    overallScore: evaluation.overallScore,
                    questionScores: evaluation.questionScores,
                    feedback: evaluation.feedback
                )
                
                await MainActor.run {
                    self.output?.didSubmit(result: result)
                }
            } catch {
                print("❌ Error evaluating test: \(error)")
                // В случае ошибки создаем fallback результат
                await MainActor.run {
                    let result = TestResult(answers: answers)
                    self.output?.didSubmit(result: result)
                }
            }
        }
    }
    
    func setCurrentTest(_ test: Test) {
        self.currentTest = test
    }
}
