//
//  TestInfoAssembly.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

enum TestInfoAssembly {
    static func build() -> UIViewController {
        let router = TestInfoRouter()
        let presenter = TestInfoPresenter()
        let testSessionService = MockTestSessionService()
        let studentService = MockStudentService()
        
        let interactor = TestInfoInteractor(
            presenter: presenter,
            testSessionService: testSessionService,
            studentService: studentService
        )
        
        let viewController = TestInfoViewController(
            router: router,
            interactor: interactor
        )
        
        router.view = viewController
        presenter.view = viewController
        
        return viewController
    }
}
