//
//  TestCreationPresenter.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation
import UIKit

final class TestCreationPresenter: TestCreationPresenterProtocol, TestCreationInteractorOutputProtocol {
    weak var view: TestCreationViewProtocol?
    var interactor: TestCreationInteractorInputProtocol?
    var router: TestCreationRouterProtocol?
    
    private var testModel = TestCreationModel()
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchGroups()
        interactor?.fetchQuestions()
    }
    
    func didSelectGroup(_ group: String) {
        testModel.selectedGroup = group
    }
    
    func didSelectQuestion(_ question: Question) {
        if !testModel.selectedQuestions.contains(where: { $0.id == question.id }) {
            testModel.selectedQuestions.append(question)
        }
    }
    
    func didDeselectQuestion(_ question: Question) {
        testModel.selectedQuestions.removeAll { $0.id == question.id }
    }
    
    func didUpdateTitle(_ title: String) {
        testModel.title = title
    }
    
    func didUpdateDescription(_ description: String) {
        testModel.description = description
    }
    
    func didUpdateDuration(_ duration: TimeInterval) {
        testModel.duration = duration
    }
    
    func didUpdateDueDate(_ dueDate: Date?) {
        testModel.startDate = dueDate
    }
    
    func didTapCreateTest() {
        guard testModel.isValid else {
            view?.showError("Заполните все обязательные поля")
            return
        }
        
        view?.showLoading()
        interactor?.createTest(testModel)
    }
    
    func didTapSelectQuestions() {
        guard let view = view as? UIViewController else { return }
        router?.presentQuestionSelection(from: view, selectedQuestions: testModel.selectedQuestions) { [weak self] selectedQuestions in
            self?.testModel.selectedQuestions = selectedQuestions
            if let testCreationVC = view as? TestCreationViewController {
                testCreationVC.updateQuestionsButton()
            }
        }
    }
    
    // MARK: - TestCreationInteractorOutputProtocol
    func didFetchGroups(_ groups: [String]) {
        view?.showGroups(groups)
    }
    
    func didFetchQuestions(_ questions: [Question]) {
        view?.showQuestions(questions)
        view?.hideLoading()
    }
    
    func didCreateTest(_ test: Test) {
        view?.hideLoading()
        view?.showSuccess("Тест успешно создан!")
    }
    
    func didFailToCreateTest(_ error: Error) {
        view?.hideLoading()
        view?.showError("Не удалось создать тест")
    }
}
