//
//  AuthenticationPresenter.swift
//  Evalyze
//
//  Created by Артём on 25.09.2025.
//

import Foundation

final class AuthenticationPresenter {
    // MARK: - VIPER Properties
    weak var view: AuthenticationViewProtocol?
    var interactor: AuthenticationInteractorProtocol?
    var router: AuthenticationRouterProtocol?
    
    // MARK: - Private Properties
    private var currentAuthMode: AuthMode = .login
    private var selectedGroup: String?
    private var availableGroups: [Group] = []
    
    private enum AuthMode {
        case login
        case registration
    }
}

// MARK: - AuthenticationPresenterProtocol
extension AuthenticationPresenter: AuthenticationPresenterProtocol {
    func viewDidLoad() {
        view?.switchToLogin()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.interactor?.loadAvailableGroups()
        }
    }
    
    func didTapSegmentedControl(selectedIndex: Int) {
        currentAuthMode = selectedIndex == 0 ? .login : .registration
        
        switch currentAuthMode {
        case .login:
            view?.switchToLogin()
        case .registration:
            view?.switchToRegistration()
        }
    }
    
    func didTapLogin(email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else {
            view?.showError("Заполните все поля")
            return
        }
        
        // Показываем индикатор загрузки
        view?.showLoading()
        
        // Вызываем interactor для выполнения логина
        interactor?.login(email: email, password: password)
    }
    
    func didTapRegistration(name: String, email: String, password: String, role: UserRole, groups: [String]) {
        // Проверяем пустые поля
        guard !name.isEmpty, !email.isEmpty, !password.isEmpty else {
            view?.showError("Заполните все поля")
            return
        }
        
        // Проверяем группы
        guard !groups.isEmpty else {
            let errorMessage = role == .student ? "Выберите группу" : "Создайте хотя бы одну группу"
            view?.showError(errorMessage)
            return
        }
        
        // Показываем индикатор загрузки
        view?.showLoading()
        
        // Вызываем interactor для выполнения регистрации
        interactor?.register(name: name, email: email, password: password, role: role, groups: groups)
    }
    
    func didSelectGroup(_ groupName: String) {
        selectedGroup = groupName
        // Можно добавить дополнительную логику для обработки выбора группы
    }
}

// MARK: - AuthenticationInteractorOutputProtocol
extension AuthenticationPresenter: AuthenticationInteractorOutputProtocol {
    func loginDidSucceed(user: User) {
        view?.hideLoading()
        
        // Сохраняем пользователя в UserManager
        UserManager.shared.setCurrentUser(user)
        
        // Показываем успешное сообщение
        view?.showSuccess("Добро пожаловать, \(user.fullName)!")
        
        // Переходим к экрану профиля
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.router?.navigateToProfile()
        }
    }
    
    func loginDidFail(error: AuthenticationError) {
        view?.hideLoading()
        router?.showError(error)
    }
    
    func registrationDidSucceed(user: User) {
        view?.hideLoading()
        
        // Сохраняем пользователя в UserManager
        UserManager.shared.setCurrentUser(user)
        
        // Показываем успешное сообщение
        view?.showSuccess("Регистрация успешна! Добро пожаловать, \(user.fullName)!")
        
        // Переходим к экрану профиля
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.router?.navigateToProfile()
        }
    }
    
    func registrationDidFail(error: AuthenticationError) {
        view?.hideLoading()
        router?.showError(error)
    }
    
    func groupsDidLoad(_ groups: [Group]) {
        availableGroups = groups
        view?.updateAvailableGroups(groups)
    }
    
    func groupsDidFailToLoad(error: GroupError) {
        // Можно показать ошибку пользователю или использовать fallback
    }
    
    func groupDidCreate(_ group: Group) {
        availableGroups.append(group)
    }
    
    func groupDidFailToCreate(error: GroupError) {
        view?.showError(error.localizedDescription)
    }
    
}

// MARK: - UserManager
final class UserManager {
    static let shared = UserManager()
    
    private init() {
        loadUserFromUserDefaults()
    }
    
    var currentUser: User?
    private let userDefaultsKey = "SavedUser"
    
    func setCurrentUser(_ user: User) {
        currentUser = user
        saveUserToUserDefaults(user)
        print("User logged in: \(user.fullName), Role: \(user.role), Groups: \(user.groups)")
    }
    
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    func logout() {
        currentUser = nil
        clearUserFromUserDefaults()
    }
    
    func setUser(_ user: User) {
        currentUser = user
        saveUserToUserDefaults(user)
    }
    
    func clearUser() {
        currentUser = nil
        clearUserFromUserDefaults()
    }
    
    func isLoggedIn() -> Bool {
        return currentUser != nil
    }
    
    // MARK: - UserDefaults Methods
    private func saveUserToUserDefaults(_ user: User) {
        do {
            let userData = try JSONEncoder().encode(user)
            UserDefaults.standard.set(userData, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
            print("User saved to UserDefaults")
        } catch {
            print("Failed to save user to UserDefaults: \(error.localizedDescription)")
        }
    }
    
    private func loadUserFromUserDefaults() {
        guard let userData = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            print("No saved user found in UserDefaults")
            return
        }
        
        do {
            let user = try JSONDecoder().decode(User.self, from: userData)
            currentUser = user
            print("User loaded from UserDefaults: \(user.fullName)")
        } catch {
            print("Failed to load user from UserDefaults: \(error.localizedDescription)")
            // Очищаем поврежденные данные
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        }
    }
    
    private func clearUserFromUserDefaults() {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
        print("User cleared from UserDefaults")
    }
}
