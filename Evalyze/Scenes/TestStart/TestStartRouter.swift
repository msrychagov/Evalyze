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
        let testCloseVC = TestInfoAssembly.build()
        view?.navigationController?.pushViewController(testCloseVC, animated: true)
    }
}
