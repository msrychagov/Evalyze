//
//  TestResultsAssembly.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import UIKit

final class TestResultsAssembly {
    static func createModule(with test: Test) -> UIViewController {
        return TestResultsRouter.createTestResultsModule(with: test)
    }
}
