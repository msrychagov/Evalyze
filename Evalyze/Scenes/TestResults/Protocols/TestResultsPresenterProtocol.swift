//
//  TestResultsPresenterProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

protocol TestResultsPresenterProtocol: AnyObject {
    var view: TestResultsViewProtocol? { get set }
    var interactor: TestResultsInteractorInputProtocol? { get set }
    var router: TestResultsRouterProtocol? { get set }
    
    func viewDidLoad()
    func didSelectQuestion(at index: Int)
    func didUpdateScore(for questionId: Int, score: Int)
}
