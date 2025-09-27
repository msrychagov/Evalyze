//
//  TestViewProtocol.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import UIKit

protocol TestViewProtocol: AnyObject {
    func showIntro(with info: String)
    func showQuestions(_ questions: [Question])
    func showQuestion(_ question: Question, index: Int, total: Int)
    func updateNavigation(canGoPrev: Bool, canGoNext: Bool)
    func showSubmitting()
    func showSubmitSuccess()
}
