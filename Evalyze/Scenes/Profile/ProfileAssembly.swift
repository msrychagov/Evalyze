//
//  ProfileAssembly.swift
//  Evalyze
//
//  Created by Артём on 27.09.2025.
//

import UIKit

final class ProfileAssembly {
    
    /// Создает модуль Profile с стандартными зависимостями
    static func createModule() -> UIViewController {
        return ProfileRouter.createModule()
    }
    
    /// Создает модуль Profile с кастомными зависимостями для DI
    static func createModuleWithCustomDependencies(
        userService: UserServiceProtocol? = nil,
        authService: ProfileAuthServiceProtocol? = nil
    ) -> UIViewController {
        return ProfileRouter.createModuleWithCustomDependencies(
            userService: userService,
            authService: authService
        )
    }
    
    /// Создает модуль Profile для тестирования с mock-сервисами
    static func createModuleForTesting(
        userService: UserServiceProtocol,
        authService: ProfileAuthServiceProtocol
    ) -> (view: ProfileViewController, presenter: ProfilePresenter, interactor: ProfileInteractor, router: ProfileRouter) {
        
        let view = ProfileViewController()
        let presenter = ProfilePresenter()
        let interactor = ProfileInteractor(
            userService: userService,
            authService: authService
        )
        let router = ProfileRouter()
        
        // VIPER connections
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return (view: view, presenter: presenter, interactor: interactor, router: router)
    }
}
