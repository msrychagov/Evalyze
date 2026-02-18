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
        let questionsCount = currentTest?.questions.count ?? 0
        let info = "Тест состоит из \(questionsCount) вопросов. Ответы сохраняются автоматически. Удачи!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.output?.didLoadIntro(info)
        }
    }

    func fetchQuestions() {
        if let currentTest = currentTest {
            print("📚 Loading questions from real test: \(currentTest.title)")
            let questions = currentTest.questions
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.output?.didLoadQuestions(questions)
            }
        } else {
            // Если тест не установлен, показываем ошибку
            print("❌ No current test set - cannot load questions")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.output?.didLoadQuestions([])
            }
        }
    }

    func submitAnswers(_ answers: [Int : String]) {
        print("🔍 Submitting answers: \(answers)")
        print("🔍 Current test: \(currentTest?.title ?? "nil")")
        
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
        print("🔧 Setting current test: \(test.title) (ID: \(test.id))")
        self.currentTest = test
    }
}
