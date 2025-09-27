//
//  ProfileProtocols.swift
//  Evalyze
//
//  Created by Артём on 27.09.2025.
//

import UIKit

// MARK: - View Protocol
protocol ProfileViewProtocol: AnyObject {
    func displayUserInfo(name: String, email: String)
    func showLoading()
    func hideLoading()
    func showError(_ message: String)
    func showLogoutConfirmation()
}

// MARK: - Presenter Protocol
protocol ProfilePresenterProtocol: AnyObject {
    func viewDidLoad()
    func didTapLogout()
    func didConfirmLogout()
    func didCancelLogout()
}

// MARK: - Interactor Protocol
protocol ProfileInteractorProtocol: AnyObject {
    func getCurrentUser()
    func logout()
}

// MARK: - Interactor Output Protocol
protocol ProfileInteractorOutputProtocol: AnyObject {
    func userDidLoad(_ user: User)
    func userDidFailToLoad(error: ProfileError)
    func logoutDidSucceed()
    func logoutDidFail(error: ProfileError)
}

// MARK: - Router Protocol
protocol ProfileRouterProtocol: AnyObject {
    func navigateToAuthentication()
    func showError(_ error: ProfileError)
}

// MARK: - Profile Error
enum ProfileError: Error, LocalizedError {
    case userNotFound
    case logoutFailed(String)
    case networkError(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "Пользователь не найден"
        case .logoutFailed(let message):
            return "Ошибка выхода: \(message)"
        case .networkError(let message):
            return "Сетевая ошибка: \(message)"
        case .unknownError:
            return "Неизвестная ошибка"
        }
    }
}
