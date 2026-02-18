//
//  TestResultsInteractorInputProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

protocol TestResultsInteractorInputProtocol: AnyObject {
    var presenter: TestResultsInteractorOutputProtocol? { get set }
    
    func fetchTestResults(for testId: String)
    func fetchStudentTestResults(for studentResult: StudentTestResult)
    func updateQuestionScore(questionId: Int, score: Int)
    func getCurrentUserRole() -> UserRole
}
