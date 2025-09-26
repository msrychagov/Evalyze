//
//  TestStartRouter.swift
//  Evalyce
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

protocol TestStartRoutingLogic {
    func routeToTestInfo()
}

final class TestStartRouter: TestStartRoutingLogic {
    weak var view: UIViewController?
    
    func routeToTestInfo() {
        // Here we'll navigate to TestInfo screen
        // For now, just show success message
        let alert = UIAlertController(
            title: "Тест запущен",
            message: "Тестирование успешно начато",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            self?.view?.navigationController?.popViewController(animated: true)
        })
        view?.present(alert, animated: true)
    }
}
