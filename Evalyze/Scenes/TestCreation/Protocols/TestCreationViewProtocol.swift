//
//  TestCreationViewProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

protocol TestCreationViewProtocol: AnyObject {
    var presenter: TestCreationPresenterProtocol? { get set }
    
    func showGroups(_ groups: [String])
    func showQuestions(_ questions: [Question])
    func showError(_ message: String)
    func showSuccess(_ message: String)
    func showLoading()
    func hideLoading()
}
