//
//  TestPresenter.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

final class TestPresenter: TestPresenterProtocol {
    weak var view: TestViewProtocol?
    var interactor: TestInteractorInputProtocol
    var router: TestRouterProtocol

    private var questions: [Question] = []
    private var currentIndex: Int = 0

    init(view: TestViewProtocol, interactor: TestInteractorInputProtocol, router: TestRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    func viewDidLoad() {
        interactor.fetchIntroInfo()
    }

    func startTest() {
        interactor.fetchQuestions()
    }

    func answerChanged(_ text: String) {
        guard currentIndex < questions.count else { return }
        questions[currentIndex].answer = text
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
                guard let self = self else { return }
                self.view?.showSubmitting()
                let answers = Dictionary(uniqueKeysWithValues: self.questions.map { ($0.id, $0.answer ?? "") })
                self.interactor.submitAnswers(answers)
            }
        }
    }

    func goToQuestion(index: Int) {
        guard index >= 0, index < questions.count else { return }
        currentIndex = index
        showCurrentQuestion()
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
        if let vc = view as? UIViewController {
            router.presentResults(from: vc, result: result)
        }
    }
}
