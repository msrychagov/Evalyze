//
//  TestCreationPresenterProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

protocol TestCreationPresenterProtocol: AnyObject {
    var view: TestCreationViewProtocol? { get set }
    var interactor: TestCreationInteractorInputProtocol? { get set }
    var router: TestCreationRouterProtocol? { get set }
    
    func viewDidLoad()
    func didSelectGroup(_ group: String)
    func didSelectQuestion(_ question: Question)
    func didDeselectQuestion(_ question: Question)
    func didUpdateTitle(_ title: String)
    func didUpdateDescription(_ description: String)
    func didUpdateDuration(_ duration: TimeInterval)
    func didUpdateDueDate(_ dueDate: Date?)
    func didTapCreateTest()
    func didTapSelectQuestions()
}
