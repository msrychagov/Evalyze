//
//  ProfileRouter.swift
//  Evalyze
//
//  Created by Артём on 27.09.2025.
//

import UIKit

final class ProfileRouter {
    weak var viewController: UIViewController?
}

// MARK: - ProfileRouterProtocol
extension ProfileRouter: ProfileRouterProtocol {
    func navigateToAuthentication() {
        DispatchQueue.main.async {
            // Создаем новый экран аутентификации
            let authViewController = AuthenticationAssembly.createModule()
            
            // Находим window scene и меняем root view controller
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first {
                
                // Анимация перехода
                UIView.transition(with: window, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    window.rootViewController = authViewController
                }, completion: nil)
            }
        }
    }
    
    func showError(_ error: ProfileError) {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Ошибка",
                message: error.localizedDescription,
                preferredStyle: .alert
            )
            
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            self.viewController?.present(alert, animated: true)
        }
    }
    
    // MARK: - Static Methods
    static func createModule() -> UIViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor()
        let router = ProfileRouter()
        
        // VIPER connections
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    static func createModuleWithCustomDependencies(
        userService: UserServiceProtocol? = nil,
        authService: ProfileAuthServiceProtocol? = nil
    ) -> UIViewController {
        let view = ProfileViewController()
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(
            userService: userService ?? UserService(),
            authService: authService ?? ProfileAuthService()
        )
        let router = ProfileRouter()
        
        // VIPER connections
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
}
