//
//  TestRouterProtocol.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

protocol TestRouterProtocol: AnyObject {
    func presentTest(from view: UIViewController)
    func presentFinishConfirmation(from view: UIViewController, confirmHandler: @escaping () -> Void)
    func presentResults(from view: UIViewController, result: TestResult)
}
