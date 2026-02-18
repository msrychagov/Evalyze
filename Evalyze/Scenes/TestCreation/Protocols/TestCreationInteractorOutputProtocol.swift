//
//  TestCreationInteractorOutputProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

protocol TestCreationInteractorOutputProtocol: AnyObject {
    func didFetchGroups(_ groups: [String])
    func didFetchQuestions(_ questions: [Question])
    func didCreateTest(_ test: Test)
    func didFailToCreateTest(_ error: Error)
}
