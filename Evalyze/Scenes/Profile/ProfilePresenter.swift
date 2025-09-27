//
//  ProfilePresenter.swift
//  Evalyze
//
//  Created by Артём on 27.09.2025.
//

import Foundation

final class ProfilePresenter {
    // MARK: - VIPER Components
    weak var view: ProfileViewProtocol?
    var interactor: ProfileInteractorProtocol?
    var router: ProfileRouterProtocol?
    
    // MARK: - Private Properties
    private var currentUser: User?
}

// MARK: - ProfilePresenterProtocol
extension ProfilePresenter: ProfilePresenterProtocol {
    func viewDidLoad() {
        view?.showLoading()
        interactor?.getCurrentUser()
    }
    
    func didTapLogout() {
        view?.showLogoutConfirmation()
    }
    
    func didConfirmLogout() {
        view?.showLoading()
        interactor?.logout()
    }
    
    func didCancelLogout() {
        // Ничего не делаем, пользователь отменил выход
    }
}

// MARK: - ProfileInteractorOutputProtocol
extension ProfilePresenter: ProfileInteractorOutputProtocol {
    func userDidLoad(_ user: User) {
        currentUser = user
        view?.hideLoading()
        view?.displayUserInfo(name: user.fullName, email: user.email)
    }
    
    func userDidFailToLoad(error: ProfileError) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
    
    func logoutDidSucceed() {
        view?.hideLoading()
        
        // Переходим на экран аутентификации (UserManager уже очищен в Interactor)
        router?.navigateToAuthentication()
    }
    
    func logoutDidFail(error: ProfileError) {
        view?.hideLoading()
        view?.showError(error.localizedDescription)
    }
}
