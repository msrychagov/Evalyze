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
    private var allQuestions: [Question] = []
    
    func viewDidLoad() {
        view?.showLoading()
        interactor?.fetchGroups()
        interactor?.fetchQuestions()
    }
    
    func didSelectGroup(_ group: String) {
        testModel.selectedGroup = group
    }
    
    func didSelectQuestion(_ question: Question) {
        if !testModel.selectedQuestions.contains(where: { $0.intId == question.intId }) {
            testModel.selectedQuestions.append(question)
        }
    }
    
    func didDeselectQuestion(_ question: Question) {
        testModel.selectedQuestions.removeAll { $0.intId == question.intId }
    }
    
    func didUpdateSelectedQuestions(_ questions: [Question]) {
        testModel.selectedQuestions = questions
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
        print("🔍 Validating test creation:")
        print("- Title: '\(testModel.title)' (isEmpty: \(testModel.title.isEmpty))")
        print("- Description: '\(testModel.description)' (isEmpty: \(testModel.description.isEmpty))")
        print("- Selected Group: \(testModel.selectedGroup ?? "nil")")
        print("- Selected Questions: \(testModel.selectedQuestions.count) questions")
        print("- Is Valid: \(testModel.isValid)")
        
        guard testModel.isValid else {
            var missingFields: [String] = []
            if testModel.title.isEmpty { missingFields.append("Название") }
            if testModel.description.isEmpty { missingFields.append("Описание") }
            if testModel.selectedGroup == nil { missingFields.append("Группа") }
            if testModel.selectedQuestions.isEmpty { missingFields.append("Вопросы") }
            
            let errorMessage = "Заполните все обязательные поля: \(missingFields.joined(separator: ", "))"
            view?.showError(errorMessage)
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
        print("📋 Presenter received \(groups.count) groups: \(groups)")
        view?.showGroups(groups)
    }
    
    func didFetchQuestions(_ questions: [Question]) {
        print("📋 Presenter received \(questions.count) questions")
        allQuestions = questions
        view?.showQuestions(questions)
        view?.hideLoading()
    }
    
    // MARK: - Public Methods
    func getAllQuestions() -> [Question]? {
        return allQuestions.isEmpty ? nil : allQuestions
    }
    
    func didCreateTest(_ test: Test) {
        view?.hideLoading()
        view?.showSuccess("Тест успешно создан!")
        
        // Уведомляем дашборд о создании нового теста
        NotificationCenter.default.post(name: NSNotification.Name("TestCreated"), object: test)
    }
    
    func didFailToCreateTest(_ error: Error) {
        view?.hideLoading()
        view?.showError("Не удалось создать тест")
    }
}
