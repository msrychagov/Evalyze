//
//  TestResultsRouterProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

protocol TestResultsRouterProtocol: AnyObject {
    static func createTestResultsModule(with test: Test) -> UIViewController
}
