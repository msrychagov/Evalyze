//
//  AuthenticationProtocols.swift
//  Evalyze
//
//  Created by Артём on 26.09.2025.
//

import Foundation
import UIKit

// MARK: - View Protocol
protocol AuthenticationViewProtocol: AnyObject {
    var presenter: AuthenticationPresenterProtocol? { get set }
    
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showSuccess(_ message: String)
    func switchToLogin()
    func switchToRegistration()
    func updateAvailableGroups(_ groups: [Group])
}

// MARK: - Presenter Protocol
protocol AuthenticationPresenterProtocol: AnyObject {
    var view: AuthenticationViewProtocol? { get set }
    var interactor: AuthenticationInteractorProtocol? { get set }
    var router: AuthenticationRouterProtocol? { get set }
    
    func viewDidLoad()
    func didTapSegmentedControl(selectedIndex: Int)
    func didTapLogin(email: String, password: String)
    func didTapRegistration(name: String, email: String, password: String, role: UserRole, groups: [String])
    func didSelectGroup(_ groupName: String)
}

// MARK: - Interactor Protocol
protocol AuthenticationInteractorProtocol: AnyObject {
    var presenter: AuthenticationInteractorOutputProtocol? { get set }
    
    func login(email: String, password: String)
    func register(name: String, email: String, password: String, role: UserRole, groups: [String])
    func validateEmail(_ email: String) -> Bool
    func validatePassword(_ password: String) -> Bool
    func validateName(_ name: String) -> Bool
    func loadAvailableGroups()
    func createGroup(name: String, createdBy: String)
}

// MARK: - Interactor Output Protocol
protocol AuthenticationInteractorOutputProtocol: AnyObject {
    func loginDidSucceed(user: User)
    func loginDidFail(error: AuthenticationError)
    func registrationDidSucceed(user: User)
    func registrationDidFail(error: AuthenticationError)
    func groupsDidLoad(_ groups: [Group])
    func groupsDidFailToLoad(error: GroupError)
    func groupDidCreate(_ group: Group)
    func groupDidFailToCreate(error: GroupError)
}

// MARK: - Router Protocol
protocol AuthenticationRouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
    
    static func createModule() -> UIViewController
    func navigateToMainApp(with user: User)
    func navigateToProfile()
    func showError(_ error: AuthenticationError)
}

// MARK: - Authentication Error
enum AuthenticationError: Error, LocalizedError {
    case invalidEmail
    case invalidStudentEmail
    case invalidTeacherEmail
    case invalidPassword
    case invalidName
    case emptyGroups
    case networkError(String)
    case serverError(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Неверный формат email"
        case .invalidStudentEmail:
            return "Студенты должны использовать email в формате: example@edu.hse.ru"
        case .invalidTeacherEmail:
            return "Преподаватели должны использовать email в формате: example@hse.ru"
        case .invalidPassword:
            return "Пароль должен содержать минимум 6 символов"
        case .invalidName:
            return "ФИО должно содержать только буквы, пробелы и не должно содержать цифры"
        case .emptyGroups:
            return "Выберите группу или создайте новую"
        case .networkError(let message):
            return "Ошибка сети: \(message)"
        case .serverError(let message):
            return "Ошибка сервера: \(message)"
        case .unknownError:
            return "Неизвестная ошибка"
        }
    }
}

// MARK: - Authentication Models
struct LoginRequest {
    let email: String
    let password: String
}

struct RegistrationRequest {
    let fullName: String
    let email: String
    let password: String
    let role: UserRole
    let groups: [String]
}
