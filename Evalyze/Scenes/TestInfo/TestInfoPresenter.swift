//
//  TestInfoPresenter.swift
//  Evalyze
//
//  Created by Малова Олеся on 26.09.2025.
//

import UIKit

protocol TestInfoPresentationLogic {
    func presentTestInfo(_ response: TestInfoModel.Load.Response)
    func presentUpdatedInfo(_ response: TestInfoModel.Update.Response)
    func presentTestClosed(_ response: TestInfoModel.CloseTest.Response)
}

final class TestInfoPresenter: TestInfoPresentationLogic {
    // MARK: - Constants
    private enum Constants {
        static let timeFormat = "%02d:%02d"
        static let progressFormat = "%.0f%%"
        static let defaultErrorMessage = "Произошла ошибка"
        static let notJoinedStatus = "Не присоединился"
        static let inProgressStatus = "Выполняется"
        static let completedStatus = "Завершен"
        static let timeSpentFormat = "%d мин"
    }
    
    // MARK: - Fields
    weak var view: TestInfoDisplayLogic?
    
    // MARK: - PresentationLogic
    func presentTestInfo(_ response: TestInfoModel.Load.Response) {
        if let error = response.error {
            let viewModel = TestInfoModel.Load.ViewModel(
                testTitle: "",
                timeRemaining: "",
                students: [],
                totalStudents: "0",
                joinedStudents: "0",
                progress: "0%",
                errorMessage: error.localizedDescription
            )
            view?.displayTestInfo(viewModel)
            return
        }
        
        let viewModel = createViewModel(from: response)
        view?.displayTestInfo(viewModel)
    }
    
    func presentUpdatedInfo(_ response: TestInfoModel.Update.Response) {
        if let error = response.error {
            let viewModel = TestInfoModel.Update.ViewModel(
                students: [],
                joinedStudents: "0",
                timeRemaining: "00:00",
                progress: "0%",
                errorMessage: error.localizedDescription
            )
            view?.displayUpdatedInfo(viewModel)
            return
        }
        
        let studentDisplays = response.studentStatuses.map { status in
            createStudentDisplay(from: status)
        }
        
        let joinedCount = response.studentStatuses.filter { $0.joined }.count
        let totalCount = response.studentStatuses.count
        let averageProgress = response.studentStatuses.filter { $0.joined }.map { $0.progress }.average()
        
        let viewModel = TestInfoModel.Update.ViewModel(
            students: studentDisplays,
            joinedStudents: "\(joinedCount)",
            timeRemaining: formatTimeRemaining(response.timeRemaining),
            progress: String(format: Constants.progressFormat, averageProgress * 100),
            errorMessage: nil
        )
        
        view?.displayUpdatedInfo(viewModel)
    }
    
    func presentTestClosed(_ response: TestInfoModel.CloseTest.Response) {
        if let error = response.error {
            let viewModel = TestInfoModel.CloseTest.ViewModel(
                success: false,
                errorMessage: error.localizedDescription
            )
            view?.displayTestClosed(viewModel)
            return
        }
        
        let viewModel = TestInfoModel.CloseTest.ViewModel(
            success: response.success,
            errorMessage: nil
        )
        
        view?.displayTestClosed(viewModel)
    }
    
    private func createViewModel(from response: TestInfoModel.Load.Response) -> TestInfoModel.Load.ViewModel {
        let testSession = response.testSession
        let studentDisplays = response.studentStatuses.map { status in
            createStudentDisplay(from: status)
        }
        
        let joinedCount = response.studentStatuses.filter { $0.joined }.count
        let totalCount = response.studentStatuses.count
        let averageProgress = response.studentStatuses.filter { $0.joined }.map { $0.progress }.average()
        let timeRemaining = calculateTimeRemaining(startTime: testSession.startTime, duration: testSession.duration)
        
        return TestInfoModel.Load.ViewModel(
            testTitle: testSession.testTitle,
            timeRemaining: formatTimeRemaining(timeRemaining),
            students: studentDisplays,
            totalStudents: "\(totalCount)",
            joinedStudents: "\(joinedCount)",
            progress: String(format: Constants.progressFormat, averageProgress * 100),
            errorMessage: nil
        )
    }
    
    private func createStudentDisplay(from status: StudentStatus) -> StudentStatusDisplay {
        let statusText: String
        let statusColor: UIColor
        let progressText: String
        let timeSpentText: String
        
        if status.joined {
            if status.progress >= 1.0 {
                statusText = Constants.completedStatus
                statusColor = .systemGreen
            } else {
                statusText = Constants.inProgressStatus
                statusColor = .systemOrange
            }
            progressText = "\(status.currentQuestion)/\(status.totalQuestions)"
            
            if let startTime = status.startTime {
                let timeSpent = Int(Date().timeIntervalSince(startTime) / 60)
                timeSpentText = String(format: Constants.timeSpentFormat, timeSpent)
            } else {
                timeSpentText = "0 мин"
            }
        } else {
            statusText = Constants.notJoinedStatus
            statusColor = .systemRed
            progressText = "0/\(status.totalQuestions)"
            timeSpentText = "0 мин"
        }
        
        return StudentStatusDisplay(
            id: status.student.id,
            name: status.student.name,
            group: status.student.group,
            status: statusText,
            statusColor: statusColor,
            progress: progressText,
            progressPercentage: status.progress,
            timeSpent: timeSpentText
        )
    }
    
    private func calculateTimeRemaining(startTime: Date, duration: TimeInterval) -> TimeInterval {
        let elapsedTime = Date().timeIntervalSince(startTime)
        let remainingTime = duration - elapsedTime
        return max(0, remainingTime)
    }
    
    private func formatTimeRemaining(_ timeInterval: TimeInterval) -> String {
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: Constants.timeFormat, minutes, seconds)
    }
}

// MARK: - Array Extension for Average Calculation
extension Array where Element == Double {
    func average() -> Double {
        guard !isEmpty else { return 0 }
        return reduce(0, +) / Double(count)
    }
}
