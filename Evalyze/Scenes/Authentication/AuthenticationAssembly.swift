//
//  AuthenticationAssembly.swift
//  Evalyze
//
//  Created by Артём on 25.09.2025.
//

import Foundation
import UIKit

final class AuthenticationAssembly {
    
    // MARK: - Module Creation
    static func createModule() -> UIViewController {
        return AuthenticationRouter.createModule()
    }
    
    // MARK: - Dependencies Configuration
    static func createModuleWithCustomDependencies(
        authService: AuthenticationServiceProtocol? = nil,
        validationService: ValidationServiceProtocol? = nil
    ) -> UIViewController {
        
        let view = AuthenticationViewController()
        let presenter = AuthenticationPresenter()
        let interactor = AuthenticationInteractor(
            authService: authService ?? AuthenticationService(),
            validationService: validationService ?? ValidationService()
        )
        let router = AuthenticationRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return view
    }
    
    // MARK: - Testing Assembly
    static func createModuleForTesting(
        mockAuthService: AuthenticationServiceProtocol,
        mockValidationService: ValidationServiceProtocol
    ) -> (
        view: AuthenticationViewController,
        presenter: AuthenticationPresenter,
        interactor: AuthenticationInteractor,
        router: AuthenticationRouter
    ) {
        
        let view = AuthenticationViewController()
        let presenter = AuthenticationPresenter()
        let interactor = AuthenticationInteractor(
            authService: mockAuthService,
            validationService: mockValidationService
        )
        let router = AuthenticationRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter
        router.viewController = view
        
        return (view: view, presenter: presenter, interactor: interactor, router: router)
    }
}
