//
//  AuthenticationRouter.swift
//  Evalyze
//
//  Created by Артём on 25.09.2025.
//

import Foundation
import UIKit

final class AuthenticationRouter {
    // MARK: - Properties
    weak var viewController: UIViewController?
}

// MARK: - AuthenticationRouterProtocol
extension AuthenticationRouter: AuthenticationRouterProtocol {
    static func createModule() -> UIViewController {
        let view = AuthenticationViewController()
        let presenter = AuthenticationPresenter()
        let interactor = AuthenticationInteractor()
        let router = AuthenticationRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    func navigateToMainApp(with user: User) {
        navigateToProfile()
    }
    
    func navigateToProfile() {
        DispatchQueue.main.async {
            // Создаем dashboard экран
            let dashboardVC = DashboardViewController()
            let navigationController = UINavigationController(rootViewController: dashboardVC)
            
            // Находим window scene и меняем root view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                
                // Анимация перехода
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = navigationController
                }, completion: nil)
            }
        }
    }
    
    func showError(_ error: AuthenticationError) {
        guard let viewController = viewController else { return }
        
        let alert = UIAlertController(
            title: "Ошибка",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
    
    // MARK: - Private Methods
    private func showSuccessAlert(message: String) {
        guard let viewController = viewController else { return }
        
        let alert = UIAlertController(
            title: "Успех",
            message: message,
            preferredStyle: .alert
        )
        
        DispatchQueue.main.async {
            viewController.present(alert, animated: true)
        }
    }
}
