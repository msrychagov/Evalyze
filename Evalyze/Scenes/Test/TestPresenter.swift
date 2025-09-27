//
//  TestPresenter.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

final class TestPresenter: TestPresenterProtocol {
    // MARK: - Dependencies
    weak var view: TestViewProtocol?
    var interactor: TestInteractorInputProtocol
    var router: TestRouterProtocol
    private let testService: TestServiceProtocol
    private let answerService: StudentTestAnswerServiceProtocol

    // MARK: - State
    private var questions: [Question] = []
    private var currentIndex: Int = 0
    private var currentTest: Test?
    private var studentAnswers: [String: String] = [:]

    // MARK: - Init
    init(view: TestViewProtocol, interactor: TestInteractorInputProtocol, router: TestRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
        self.testService = TestService()
        self.answerService = StudentTestAnswerService()
    }

    // MARK: - Lifecycle
    func viewDidLoad() {
        interactor.fetchIntroInfo()
    }
    
    func setCurrentTest(_ test: Test) {
        currentTest = test
    }

    func startTest() {
        interactor.fetchQuestions()
    }

    // MARK: - User actions
    func answerChanged(_ text: String) {
        guard currentIndex < questions.count else { return }
        questions[currentIndex].answer = text
        didAnswerQuestion(text)
    }

    func didAnswerQuestion(_ answer: String) {
        let questionId = String(currentIndex + 1)
        studentAnswers[questionId] = answer
        print("📝 Saved answer for question \(questionId): \(answer)")
    }

    func nextTapped() {
        guard currentIndex < (questions.count - 1) else { return }
        currentIndex += 1
        showCurrentQuestion()
    }

    func prevTapped() {
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        showCurrentQuestion()
    }

    func finishTapped() {
        if let vc = view as? UIViewController {
            router.presentFinishConfirmation(from: vc) { [weak self] in
                self?.submitAnswers()
            }
        }
    }

    func forceFinish() {
        submitAnswers()
    }

    func goToQuestion(index: Int) {
        guard index >= 0, index < questions.count else { return }
        currentIndex = index
        showCurrentQuestion()
    }

    // MARK: - Private helpers
    private func submitAnswers() {
        view?.showSubmitting()
        let answers = Dictionary(uniqueKeysWithValues: questions.enumerated().map { (index, question) in 
            (index + 1, question.answer ?? "") 
        })
        interactor.submitAnswers(answers)
    }

    private func showCurrentQuestion() {
        view?.showQuestion(questions[currentIndex], index: currentIndex + 1, total: questions.count)
        updateNavButtons()
    }

    private func updateNavButtons() {
        let canPrev = currentIndex > 0
        let canNext = currentIndex < (questions.count - 1)
        view?.updateNavigation(canGoPrev: canPrev, canGoNext: canNext)
    }
}

// MARK: - TestInteractorOutputProtocol
extension TestPresenter: TestInteractorOutputProtocol {
    func didLoadIntro(_ info: String) {
        view?.showIntro(with: info)
    }

    func didLoadQuestions(_ questions: [Question]) {
        self.questions = questions
        view?.showQuestions(questions)
        if !questions.isEmpty {
            currentIndex = 0
            showCurrentQuestion()
        }
    }

    func didSubmit(result: TestResult) {
        view?.showSubmitSuccess()
        
        print("🚀 Starting test submission process...")
        print("📊 Test result: overallScore=\(result.overallScore ?? 0), questionScores=\(result.questionScores?.count ?? 0)")
        print("📝 Student answers: \(studentAnswers)")
        
        // Сохраняем завершенный тест и ответы студента в Firebase
        if let test = currentTest, let currentUser = UserManager.shared.getCurrentUser() {
            print("✅ Found test and user: testId=\(test.id), userId=\(currentUser.id)")
            let score = Int(result.overallScore ?? 0)
            
            // Обновляем статус теста
            testService.markTestAsCompleted(testId: test.id, score: score) { [weak self] testResult in
                switch testResult {
                case .success:
                    print("✅ Test marked as completed in Firebase")
                    
                    // Сохраняем ответы студента
                    let studentAnswer = StudentTestAnswer(
                        testId: test.id,
                        studentId: currentUser.id,
                        answers: self?.studentAnswers ?? [:],
                        overallScore: result.overallScore ?? 0,
                        questionScores: result.questionScores ?? [],
                        feedback: result.feedback ?? ""
                    )
                    
                    print("💾 Saving student answer: \(studentAnswer)")
                    
                    self?.answerService.saveStudentAnswers(studentAnswer) { answerResult in
                        switch answerResult {
                        case .success:
                            print("✅ Student answers saved successfully")
                        case .failure(let error):
                            print("❌ Failed to save student answers: \(error.localizedDescription)")
                        }
                    }
                    
                    // Отправляем уведомление о завершении теста
                    NotificationCenter.default.post(name: NSNotification.Name("TestCompleted"), object: nil)
                case .failure(let error):
                    print("❌ Failed to mark test as completed: \(error.localizedDescription)")
                }
            }
        } else {
            print("❌ Missing test or user: test=\(currentTest?.id ?? "nil"), user=\(UserManager.shared.getCurrentUser()?.id ?? "nil")")
        }
        
        if let vc = view as? UIViewController {
            router.presentResults(from: vc, result: result)
        }
    }
}
