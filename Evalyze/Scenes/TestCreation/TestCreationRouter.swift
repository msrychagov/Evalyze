//
//  TestCreationRouter.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import UIKit

final class TestCreationRouter: TestCreationRouterProtocol {
    static func createModule() -> UIViewController {
        let view = TestCreationViewController()
        let presenter = TestCreationPresenter()
        let interactor = TestCreationInteractor() // Использует default dependencies
        let router = TestCreationRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func presentQuestionSelection(from view: UIViewController, selectedQuestions: [Question], completion: @escaping ([Question]) -> Void) {
        // Получаем вопросы из презентера
        guard let presenter = (view as? TestCreationViewController)?.presenter as? TestCreationPresenter,
              let questions = presenter.getAllQuestions() else {
            // Fallback - создаем пустой список
            let questionSelectionVC = QuestionSelectionViewController(
                questions: [],
                selectedQuestions: selectedQuestions,
                completion: completion
            )
            let navigationController = UINavigationController(rootViewController: questionSelectionVC)
            view.present(navigationController, animated: true)
            return
        }
        
        let questionSelectionVC = QuestionSelectionViewController(
            questions: questions,
            selectedQuestions: selectedQuestions,
            completion: completion
        )
        let navigationController = UINavigationController(rootViewController: questionSelectionVC)
        view.present(navigationController, animated: true)
    }
    
    func dismissToDashboard(from view: UIViewController) {
        view.dismiss(animated: true) {
            // Обновляем дашборд после создания теста
            if let navigationController = view.presentingViewController as? UINavigationController,
               let dashboardVC = navigationController.viewControllers.first as? DashboardViewController {
                dashboardVC.refreshCurrentTestsList()
            } else if let dashboardVC = view.presentingViewController as? DashboardViewController {
                dashboardVC.refreshCurrentTestsList()
            }
        }
    }
}
