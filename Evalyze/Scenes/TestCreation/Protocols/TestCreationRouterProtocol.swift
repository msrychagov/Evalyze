//
//  TestCreationRouterProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import UIKit

protocol TestCreationRouterProtocol: AnyObject {
    func presentQuestionSelection(from view: UIViewController, selectedQuestions: [Question], completion: @escaping ([Question]) -> Void)
    func dismissToDashboard(from view: UIViewController)
}
