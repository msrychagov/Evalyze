//
//  TestInteractorInputProtocol.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

protocol TestInteractorInputProtocol: AnyObject {
    func fetchIntroInfo()
    func fetchQuestions()
    func submitAnswers(_ answers: [Int: String])
}
