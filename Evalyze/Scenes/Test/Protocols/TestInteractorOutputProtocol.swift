//
//  TestInteractorOutputProtocol.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

protocol TestInteractorOutputProtocol: AnyObject {
    func didLoadIntro(_ info: String)
    func didLoadQuestions(_ questions: [Question])
    func didSubmit(result: TestResult)
}
