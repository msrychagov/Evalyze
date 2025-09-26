//
//  TestInfoRouter.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

protocol TestInfoRoutingLogic {
    func routeToTestClosed()
}

final class TestInfoRouter: TestInfoRoutingLogic {
    weak var view: UIViewController?
    
    func routeToTestClosed() {
        // Navigate to test results screen
        //let testCloseVC = TestCloseAssembly.build()
        //view?.navigationController?.pushViewController(testCloseVC, animated: true)
    }
}
