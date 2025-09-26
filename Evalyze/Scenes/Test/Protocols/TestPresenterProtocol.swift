//
//  TestPresenterProtocol.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

protocol TestPresenterProtocol: AnyObject {
    func viewDidLoad()
    func startTest()
    func answerChanged(_ text: String)
    func nextTapped()
    func prevTapped()
    func finishTapped()
    func goToQuestion(index: Int)
    func forceFinish()
}
