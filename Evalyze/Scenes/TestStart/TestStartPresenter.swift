//
//  TestStartPresenter.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

protocol TestStartPresentationLogic {
    func presentStart(_ response: TestStartModel.Start.Response)
    func presentTests(_ response: TestStartModel.LoadTests.Response)
    func presentStudents(_ response: TestStartModel.LoadStudents.Response)
    func presentSelectedTest(_ response: TestStartModel.SelectTest.Response)
    func presentUpdatedStudents(_ response: TestStartModel.ToggleStudent.Response)
    func presentTestStarted(_ response: TestStartModel.StartTest.Response)
}

final class TestStartPresenter: TestStartPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        static let durationFormat = "%d мин"
        static let questionsFormat = "%d вопросов"
        static let defaultErrorMessage = "Произошла ошибка"
        static let noTestsMessage = "Нет доступных тестов"
        static let noStudentsMessage = "Нет доступных студентов"
    }
    
    // MARK: - Fields
    weak var view: TestStartDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentStart(_ response: TestStartModel.Start.Response) {
        let testDisplays = response.availableTests.map { test in
            TestDisplay(
                id: test.id,
                title: test.title,
                duration: String(format: Constants.durationFormat, test.duration),
                questionCount: String(format: Constants.questionsFormat, test.questionCount),
                isSelected: test.id == response.selectedTestId
            )
        }
        
        let studentDisplays = response.availableStudents.map { student in
            StudentDisplay(
                id: student.id,
                name: student.name,
                group: student.group,
                isSelected: response.selectedStudentIds.contains(student.id)
            )
        }
        
        let isStartButtonEnabled = response.selectedTestId != nil && !response.selectedStudentIds.isEmpty
        
        let viewModel = TestStartModel.Start.ViewModel(
            tests: testDisplays,
            students: studentDisplays,
            isStartButtonEnabled: isStartButtonEnabled,
            errorMessage: nil
        )
        
        view?.displayStart(viewModel)
    }
    
    func presentTests(_ response: TestStartModel.LoadTests.Response) {
        if let error = response.error {
            let viewModel = TestStartModel.LoadTests.ViewModel(
                tests: [],
                errorMessage: error.localizedDescription
            )
            view?.displayTests(viewModel)
            return
        }
        
        let testDisplays = response.tests.map { test in
            TestDisplay(
                id: test.id,
                title: test.title,
                duration: String(format: Constants.durationFormat, test.duration),
                questionCount: String(format: Constants.questionsFormat, test.questionCount),
                isSelected: false
            )
        }
        
        let viewModel = TestStartModel.LoadTests.ViewModel(
            tests: testDisplays,
            errorMessage: testDisplays.isEmpty ? Constants.noTestsMessage : nil
        )
        
        view?.displayTests(viewModel)
    }
    
    func presentStudents(_ response: TestStartModel.LoadStudents.Response) {
        if let error = response.error {
            let viewModel = TestStartModel.LoadStudents.ViewModel(
                students: [],
                errorMessage: error.localizedDescription
            )
            view?.displayStudents(viewModel)
            return
        }
        
        let studentDisplays = response.students.map { student in
            StudentDisplay(
                id: student.id,
                name: student.name,
                group: student.group,
                isSelected: false
            )
        }
        
        let viewModel = TestStartModel.LoadStudents.ViewModel(
            students: studentDisplays,
            errorMessage: studentDisplays.isEmpty ? Constants.noStudentsMessage : nil
        )
        
        view?.displayStudents(viewModel)
    }
    
    func presentSelectedTest(_ response: TestStartModel.SelectTest.Response) {
        if let error = response.error {
            let viewModel = TestStartModel.SelectTest.ViewModel(
                selectedTestId: nil,
                students: [],
                isStartButtonEnabled: false,
                errorMessage: error.localizedDescription
            )
            view?.displaySelectedTest(viewModel)
            return
        }
        
        let studentDisplays = response.students.map { student in
            StudentDisplay(
                id: student.id,
                name: student.name,
                group: student.group,
                isSelected: false
            )
        }
        
        let isStartButtonEnabled = response.selectedTestId != nil
        
        let viewModel = TestStartModel.SelectTest.ViewModel(
            selectedTestId: response.selectedTestId,
            students: studentDisplays,
            isStartButtonEnabled: isStartButtonEnabled,
            errorMessage: nil
        )
        
        view?.displaySelectedTest(viewModel)
    }
    
    func presentUpdatedStudents(_ response: TestStartModel.ToggleStudent.Response) {
        if let error = response.error {
            let viewModel = TestStartModel.ToggleStudent.ViewModel(
                students: [],
                isStartButtonEnabled: false,
                errorMessage: error.localizedDescription
            )
            view?.displayUpdatedStudents(viewModel)
            return
        }
        
        let studentDisplays = response.students.map { student in
            StudentDisplay(
                id: student.id,
                name: student.name,
                group: student.group,
                isSelected: response.selectedStudentIds.contains(student.id)
            )
        }
        
        let isStartButtonEnabled = response.selectedTestId != nil && !response.selectedStudentIds.isEmpty
        
        let viewModel = TestStartModel.ToggleStudent.ViewModel(
            students: studentDisplays,
            isStartButtonEnabled: isStartButtonEnabled,
            errorMessage: nil
        )
        
        view?.displayUpdatedStudents(viewModel)
    }
    
    func presentTestStarted(_ response: TestStartModel.StartTest.Response) {
        if let error = response.error {
            let viewModel = TestStartModel.StartTest.ViewModel(
                success: false,
                errorMessage: error.localizedDescription
            )
            view?.displayTestStarted(viewModel)
            return
        }
        
        let viewModel = TestStartModel.StartTest.ViewModel(
            success: response.success,
            errorMessage: nil
        )
        
        view?.displayTestStarted(viewModel)
    }
}
