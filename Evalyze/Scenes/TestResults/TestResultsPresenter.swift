//
//  TestResultsPresenter.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

final class TestResultsPresenter: TestResultsPresenterProtocol, TestResultsInteractorOutputProtocol {
    weak var view: TestResultsViewProtocol?
    var interactor: TestResultsInteractorInputProtocol?
    var router: TestResultsRouterProtocol?
    
    private let test: Test
    
    init(test: Test) {
        self.test = test
    }
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchTestResults(for: test.id)
    }
    
    func didSelectQuestion(at index: Int) {
        // Handle question selection if needed
    }
    
    func didUpdateScore(for questionId: Int, score: Int) {
        interactor?.updateQuestionScore(questionId: questionId, score: score)
    }
    
    // MARK: - TestResultsInteractorOutputProtocol
    func didFetchTestResults(_ results: [QuestionResult]) {
        view?.hideLoading()
        view?.showTestResults(results)
    }
    
    func didFailToFetchResults(_ error: Error) {
        view?.hideLoading()
        view?.showError("Не удалось загрузить результаты теста")
    }
    
    func didUpdateScoreSuccessfully() {
        // Score updated successfully
    }
    
    func didFailToUpdateScore(_ error: Error) {
        view?.showError("Не удалось обновить оценку")
    }
}
