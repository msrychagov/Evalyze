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
        let interactor = TestCreationInteractor()
        let router = TestCreationRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        
        return view
    }
    
    func presentQuestionSelection(from view: UIViewController, selectedQuestions: [Question], completion: @escaping ([Question]) -> Void) {
        let questionSelectionVC = QuestionSelectionViewController(
            questions: TestCreationModel.mockQuestions,
            selectedQuestions: selectedQuestions,
            completion: completion
        )
        let navigationController = UINavigationController(rootViewController: questionSelectionVC)
        view.present(navigationController, animated: true)
    }
    
    func dismissToDashboard(from view: UIViewController) {
        view.dismiss(animated: true)
    }
}
