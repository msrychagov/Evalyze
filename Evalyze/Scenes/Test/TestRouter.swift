//
//  TestRouter.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

final class TestRouter: TestRouterProtocol {
    static func assembleModule() -> UIViewController {
        let introVC = TestIntroViewController()
        let interactor = TestInteractor()
        let router = TestRouter()
        let presenter = TestPresenter(view: introVC, interactor: interactor, router: router)
        introVC.presenter = presenter
        interactor.output = presenter
        return introVC
    }

    func presentTest(from view: UIViewController) {
        let testVC = TestViewController()
        let interactor = TestInteractor()
        let router = self
        let presenter = TestPresenter(view: testVC, interactor: interactor, router: router)
        testVC.presenter = presenter
        interactor.output = presenter
        view.navigationController?.pushViewController(testVC, animated: true)
    }
    
    func presentTest(from view: UIViewController, test: Test) {
        let testVC = TestViewController()
        let interactor = TestInteractor()
        let router = self
        let presenter = TestPresenter(view: testVC, interactor: interactor, router: router)
        testVC.presenter = presenter
        interactor.output = presenter
        interactor.setCurrentTest(test) // Устанавливаем тест для оценки
        presenter.setCurrentTest(test) // Устанавливаем тест в presenter для сохранения статуса
        view.navigationController?.pushViewController(testVC, animated: true)
    }

    func presentFinishConfirmation(from view: UIViewController, confirmHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: "Завершить тест?",
            message: "Вы уверены, что хотите завершить и отправить ответы?",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
        alert.addAction(UIAlertAction(title: "Завершить", style: .destructive, handler: { _ in confirmHandler() }))
        view.present(alert, animated: true)
    }

    func presentResults(from view: UIViewController, result: TestResult) {
        let resultsVC = TestFinishViewController(result: result)
        view.navigationController?.pushViewController(resultsVC, animated: true)
    }
}
