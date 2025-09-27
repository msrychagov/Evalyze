//
//  TestCreationInteractorInputProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

protocol TestCreationInteractorInputProtocol: AnyObject {
    var presenter: TestCreationInteractorOutputProtocol? { get set }
    
    func fetchGroups()
    func fetchQuestions()
    func createTest(_ testModel: TestCreationModel)
}
