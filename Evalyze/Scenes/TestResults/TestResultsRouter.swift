//
//  TestResultsRouter.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

final class TestResultsRouter: TestResultsRouterProtocol {
    static func createTestResultsModule(with test: Test) -> UIViewController {
        let view = TestResultsViewController()
        let presenter = TestResultsPresenter(test: test)
        let interactor = TestResultsInteractor()
        let router = TestResultsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    static func createStudentsListModule(with test: Test) -> UIViewController {
        let view = StudentsListViewController(test: test)
        return view
    }
    
    static func createStudentTestResultsModule(with studentResult: StudentTestResult) -> UIViewController {
        let view = TestResultsViewController()
        let presenter = TestResultsPresenter(studentResult: studentResult)
        let interactor = TestResultsInteractor()
        let router = TestResultsRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        // Устанавливаем информацию о студенте
        view.setStudentResult(studentResult)
        
        return view
    }
}
