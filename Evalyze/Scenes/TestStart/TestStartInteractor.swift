//
//  TestStartInteractor.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

protocol TestServiceProtocol {
    func fetchAvailableTests(completion: @escaping (Result<[Test], Error>) -> Void)
}

protocol StudentServiceProtocol {
    func fetchAvailableStudents(completion: @escaping (Result<[Student], Error>) -> Void)
}

protocol TestSessionServiceProtocol {
    func startTestSession(testId: String, studentIds: [String], completion: @escaping (Result<Void, Error>) -> Void)
}

protocol TestStartBusinessLogic {
    typealias Model = TestStartModel
    func loadStart(_ request: Model.Start.Request)
    func loadTests(_ request: Model.LoadTests.Request)
    func loadStudents(_ request: Model.LoadStudents.Request)
    func loadSelectTest(_ request: Model.SelectTest.Request)
    func loadToggleStudent(_ request: Model.ToggleStudent.Request)
    func loadStartTest(_ request: Model.StartTest.Request)
}

protocol TestStartDataStore {
    var selectedTestId: String? { get set }
    var selectedStudentIds: [String] { get set }
    var availableTests: [Test] { get }
    var availableStudents: [Student] { get }
}

final class TestStartInteractor: TestStartBusinessLogic, TestStartDataStore {
    // MARK: - Fields
    private let presenter: TestStartPresentationLogic
    private let testService: TestServiceProtocol
    private let studentService: StudentServiceProtocol
    private let testSessionService: TestSessionServiceProtocol
    
    var selectedTestId: String?
    var selectedStudentIds: [String] = []
    var availableTests: [Test] = []
    var availableStudents: [Student] = []
    
    // MARK: - Lifecycle
    init(
        presenter: TestStartPresentationLogic,
        testService: TestServiceProtocol,
        studentService: StudentServiceProtocol,
        testSessionService: TestSessionServiceProtocol
    ) {
        self.presenter = presenter
        self.testService = testService
        self.studentService = studentService
        self.testSessionService = testSessionService
    }
    
    // MARK: - BusinessLogic
    func loadStart(_ request: Model.Start.Request) {
        loadTests(Model.LoadTests.Request())
        loadStudents(Model.LoadStudents.Request())
    }
    
    func loadTests(_ request: Model.LoadTests.Request) {
        testService.fetchAvailableTests { [weak self] result in
            switch result {
            case .success(let tests):
                self?.availableTests = tests
                let response = Model.LoadTests.Response(tests: tests, error: nil)
                self?.presenter.presentTests(response)
                
                // Present initial state
                self?.presentInitialState()
                
            case .failure(let error):
                let response = Model.LoadTests.Response(tests: [], error: error)
                self?.presenter.presentTests(response)
            }
        }
    }
    
    func loadStudents(_ request: Model.LoadStudents.Request) {
        studentService.fetchAvailableStudents { [weak self] result in
            switch result {
            case .success(let students):
                self?.availableStudents = students
                let response = Model.LoadStudents.Response(students: students, error: nil)
                self?.presenter.presentStudents(response)
                
                // Present initial state
                self?.presentInitialState()
                
            case .failure(let error):
                let response = Model.LoadStudents.Response(students: [], error: error)
                self?.presenter.presentStudents(response)
            }
        }
    }
    
    func loadSelectTest(_ request: Model.SelectTest.Request) {
        selectedTestId = request.testId
        
        let response = Model.SelectTest.Response(
            selectedTestId: selectedTestId,
            students: availableStudents,
            error: nil
        )
        presenter.presentSelectedTest(response)
    }
    
    func loadToggleStudent(_ request: Model.ToggleStudent.Request) {
        if selectedStudentIds.contains(request.studentId) {
            selectedStudentIds.removeAll { $0 == request.studentId }
        } else {
            selectedStudentIds.append(request.studentId)
        }
        
        let response = Model.ToggleStudent.Response(
            selectedStudentIds: selectedStudentIds,
            students: availableStudents,
            selectedTestId: selectedTestId,
            error: nil
        )
        presenter.presentUpdatedStudents(response)
    }
    
    func loadStartTest(_ request: Model.StartTest.Request) {
        guard let testId = selectedTestId else {
            let error = NSError(domain: "TestStart", code: 1, userInfo: [NSLocalizedDescriptionKey: "Тест не выбран"])
            let response = Model.StartTest.Response(success: false, error: error)
            presenter.presentTestStarted(response)
            return
        }
        
        guard !selectedStudentIds.isEmpty else {
            let error = NSError(domain: "TestStart", code: 2, userInfo: [NSLocalizedDescriptionKey: "Не выбраны студенты"])
            let response = Model.StartTest.Response(success: false, error: error)
            presenter.presentTestStarted(response)
            return
        }
        
        testSessionService.startTestSession(
            testId: testId,
            studentIds: selectedStudentIds
        ) { [weak self] result in
            switch result {
            case .success:
                let response = Model.StartTest.Response(success: true, error: nil)
                self?.presenter.presentTestStarted(response)
            case .failure(let error):
                let response = Model.StartTest.Response(success: false, error: error)
                self?.presenter.presentTestStarted(response)
            }
        }
    }
    
    private func presentInitialState() {
        guard !availableTests.isEmpty && !availableStudents.isEmpty else { return }
        
        let response = Model.Start.Response(
            availableTests: availableTests,
            availableStudents: availableStudents,
            selectedTestId: selectedTestId,
            selectedStudentIds: selectedStudentIds
        )
        presenter.presentStart(response)
    }
}
