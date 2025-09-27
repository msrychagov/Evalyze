//
//  TestCreationInteractor.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

final class TestCreationInteractor: TestCreationInteractorInputProtocol {
    weak var presenter: TestCreationInteractorOutputProtocol?
    
    func fetchGroups() {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let groups = TestCreationModel.mockGroups
            self.presenter?.didFetchGroups(groups)
        }
    }
    
    func fetchQuestions() {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let questions = TestCreationModel.mockQuestions
            self.presenter?.didFetchQuestions(questions)
        }
    }
    
    func createTest(_ testModel: TestCreationModel) {
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Create new test
            let newTest = Test(
                id: UUID().uuidString,
                title: testModel.title,
                description: testModel.description,
                questions: testModel.selectedQuestions,
                duration: testModel.duration,
                status: .upcoming,
                createdAt: Date(),
                dueDate: testModel.startDate,
                completedAt: nil,
                score: nil,
                maxScore: testModel.selectedQuestions.count * 10
            )
            
            // In a real app, this would save to the server
            // For now, we'll just simulate success
            self.presenter?.didCreateTest(newTest)
        }
    }
}
