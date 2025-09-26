//
//  TestInfoInteractor.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

protocol TestInfoBusinessLogic {
    func loadTestInfo(_ request: TestInfoModel.Load.Request)
    func loadUpdate(_ request: TestInfoModel.Update.Request)
    func loadCloseTest(_ request: TestInfoModel.CloseTest.Request)
}

protocol TestInfoDataStore {
    var testSession: TestSession? { get }
    var studentStatuses: [StudentStatus] { get }
}

final class TestInfoInteractor: TestInfoBusinessLogic, TestInfoDataStore {
    // MARK: - Fields
    private let presenter: TestInfoPresentationLogic
    private let testSessionService: TestSessionServiceProtocol
    private let studentService: StudentServiceProtocol
    
    var testSession: TestSession?
    var studentStatuses: [StudentStatus] = []
    
    // MARK: - Lifecycle
    init(
        presenter: TestInfoPresentationLogic,
        testSessionService: TestSessionServiceProtocol,
        studentService: StudentServiceProtocol
    ) {
        self.presenter = presenter
        self.testSessionService = testSessionService
        self.studentService = studentService
        
        // For demo purposes, create a mock test session
        setupMockData()
    }
    
    // MARK: - BusinessLogic
    func loadTestInfo(_ request: TestInfoModel.Load.Request) {
        guard let testSession = testSession else {
            let error = NSError(domain: "TestInfo", code: 1, userInfo: [NSLocalizedDescriptionKey: "Сессия теста не найдена"])
            let response = TestInfoModel.Load.Response(testSession: createMockTestSession(), studentStatuses: [], error: error)
            presenter.presentTestInfo(response)
            return
        }
        
        // Simulate loading student statuses
        testSessionService.getStudentStatuses(testSessionId: testSession.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let statuses):
                    self?.studentStatuses = statuses
                    let response = TestInfoModel.Load.Response(
                        testSession: testSession,
                        studentStatuses: statuses,
                        error: nil
                    )
                    self?.presenter.presentTestInfo(response)
                    
                case .failure(let error):
                    let response = TestInfoModel.Load.Response(
                        testSession: testSession,
                        studentStatuses: [],
                        error: error
                    )
                    self?.presenter.presentTestInfo(response)
                }
            }
        }
    }
    
    func loadUpdate(_ request: TestInfoModel.Update.Request) {
        guard let testSession = testSession else { return }
        
        // Simulate updated student statuses
        testSessionService.getStudentStatuses(testSessionId: testSession.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let statuses):
                    self?.studentStatuses = statuses
                    let timeRemaining = self?.calculateTimeRemaining() ?? 0
                    
                    let response = TestInfoModel.Update.Response(
                        studentStatuses: statuses,
                        timeRemaining: timeRemaining,
                        error: nil
                    )
                    self?.presenter.presentUpdatedInfo(response)
                    
                case .failure(let error):
                    let response = TestInfoModel.Update.Response(
                        studentStatuses: self?.studentStatuses ?? [],
                        timeRemaining: self?.calculateTimeRemaining() ?? 0,
                        error: error
                    )
                    self?.presenter.presentUpdatedInfo(response)
                }
            }
        }
    }
    
    func loadCloseTest(_ request: TestInfoModel.CloseTest.Request) {
        guard let testSession = testSession else {
            let error = NSError(domain: "TestInfo", code: 1, userInfo: [NSLocalizedDescriptionKey: "Сессия теста не найдена"])
            let response = TestInfoModel.CloseTest.Response(success: false, error: error)
            presenter.presentTestClosed(response)
            return
        }
        
        testSessionService.closeTestSession(testSessionId: testSession.id) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.testSession = TestSession(
                        id: testSession.id,
                        testId: testSession.testId,
                        testTitle: testSession.testTitle,
                        startTime: testSession.startTime,
                        duration: testSession.duration,
                        status: .finished,
                        studentIds: testSession.studentIds
                    )
                    let response = TestInfoModel.CloseTest.Response(success: true, error: nil)
                    self?.presenter.presentTestClosed(response)
                    
                case .failure(let error):
                    let response = TestInfoModel.CloseTest.Response(success: false, error: error)
                    self?.presenter.presentTestClosed(response)
                }
            }
        }
    }
    
    private func calculateTimeRemaining() -> TimeInterval {
        guard let testSession = testSession else { return 0 }
        let elapsedTime = Date().timeIntervalSince(testSession.startTime)
        let remainingTime = testSession.duration - elapsedTime
        return max(0, remainingTime)
    }
    
    private func setupMockData() {
        // Create a mock test session for demo
        testSession = createMockTestSession()
    }
    
    private func createMockTestSession() -> TestSession {
        return TestSession(
            id: "mock_session_1",
            testId: "1",
            testTitle: "Основы программирования на Swift",
            startTime: Date().addingTimeInterval(-1200), // Started 20 minutes ago
            duration: 3600, // 1 hour
            status: .active,
            studentIds: ["1", "2", "3", "4", "5"]
        )
    }
}
