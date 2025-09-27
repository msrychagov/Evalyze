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
}
