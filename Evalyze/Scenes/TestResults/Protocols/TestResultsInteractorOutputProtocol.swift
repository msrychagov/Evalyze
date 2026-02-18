//
//  TestResultsInteractorOutputProtocol.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

protocol TestResultsInteractorOutputProtocol: AnyObject {
    func didFetchTestResults(_ results: [QuestionResult])
    func didFailToFetchResults(_ error: Error)
    func didUpdateScoreSuccessfully()
    func didFailToUpdateScore(_ error: Error)
}
