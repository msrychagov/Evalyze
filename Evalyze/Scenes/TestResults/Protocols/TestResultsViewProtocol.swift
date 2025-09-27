//
//  TestResultsViewProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

protocol TestResultsViewProtocol: AnyObject {
    var presenter: TestResultsPresenterProtocol? { get set }
    
    func showTestResults(_ results: [QuestionResult])
    func showError(_ message: String)
    func showLoading()
    func hideLoading()
}
