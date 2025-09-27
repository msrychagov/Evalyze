//
//  ProfileInteractor.swift
//  Evalyze
//
//  Created by Артём on 27.09.2025.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class ProfileInteractor {
    // MARK: - VIPER Components
    weak var presenter: ProfileInteractorOutputProtocol?
    
    // MARK: - Services
    private let userService: UserServiceProtocol
    private let authService: ProfileAuthServiceProtocol
    
    // MARK: - Initialization
    init(userService: UserServiceProtocol = UserService(),
         authService: ProfileAuthServiceProtocol = ProfileAuthService()) {
        self.userService = userService
        self.authService = authService
    }
}

// MARK: - ProfileInteractorProtocol
extension ProfileInteractor: ProfileInteractorProtocol {
    func getCurrentUser() {
        // Сначала пытаемся получить пользователя из UserManager
        if let cachedUser = UserManager.shared.currentUser {
            presenter?.userDidLoad(cachedUser)
            return
        }
        
        // Если нет кэшированного пользователя, получаем из Firebase
        userService.getCurrentUser { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    UserManager.shared.setUser(user)
                    self?.presenter?.userDidLoad(user)
                case .failure(let error):
                    let profileError = self?.mapUserServiceError(error) ?? .unknownError
                    self?.presenter?.userDidFailToLoad(error: profileError)
                }
            }
        }
    }
    
    func logout() {
        authService.logout { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    // Очищаем UserManager (который автоматически очистит UserDefaults)
                    UserManager.shared.clearUser()
                    self?.presenter?.logoutDidSucceed()
                case .failure(let error):
                    let profileError = self?.mapAuthServiceError(error) ?? .unknownError
                    self?.presenter?.logoutDidFail(error: profileError)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func mapUserServiceError(_ error: UserServiceError) -> ProfileError {
        switch error {
        case .userNotFound:
            return .userNotFound
        case .networkError(let message):
            return .networkError(message)
        case .unknownError:
            return .unknownError
        }
    }
    
    private func mapAuthServiceError(_ error: ProfileAuthError) -> ProfileError {
        switch error {
        case .logoutFailed(let message):
            return .logoutFailed(message)
        case .networkError(let message):
            return .networkError(message)
        case .unknownError:
            return .unknownError
        }
    }
}

// MARK: - Services Protocols
protocol UserServiceProtocol {
    func getCurrentUser(completion: @escaping (Result<User, UserServiceError>) -> Void)
}

protocol ProfileAuthServiceProtocol {
    func logout(completion: @escaping (Result<Void, ProfileAuthError>) -> Void)
}

// MARK: - Service Errors
enum UserServiceError: Error {
    case userNotFound
    case networkError(String)
    case unknownError
}

enum ProfileAuthError: Error {
    case logoutFailed(String)
    case networkError(String)
    case unknownError
}

// MARK: - Services Implementation
final class UserService: UserServiceProtocol {
    private let db = Firestore.firestore()
    private let auth = Auth.auth()
    
    func getCurrentUser(completion: @escaping (Result<User, UserServiceError>) -> Void) {
        guard let currentUser = auth.currentUser else {
            completion(.failure(.userNotFound))
            return
        }
        
        db.collection("users").document(currentUser.uid).getDocument { document, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let document = document,
                  document.exists,
                  let data = document.data(),
                  let user = self.parseUserData(uid: currentUser.uid, data: data) else {
                completion(.failure(.userNotFound))
                return
            }
            
            completion(.success(user))
        }
    }
    
    private func parseUserData(uid: String, data: [String: Any]) -> User? {
        guard let email = data["email"] as? String,
              let fullName = data["fullName"] as? String,
              let roleString = data["role"] as? String,
              let role = UserRole(rawValue: roleString),
              let groups = data["groups"] as? [String],
              let createdAtTimestamp = data["createdAt"] as? Timestamp else {
            return nil
        }
        
        return User(
            id: uid,
            email: email,
            fullName: fullName,
            role: role,
            groups: groups,
            createdAt: createdAtTimestamp.dateValue()
        )
    }
}

final class ProfileAuthService: ProfileAuthServiceProtocol {
    private let auth = Auth.auth()
    
    func logout(completion: @escaping (Result<Void, ProfileAuthError>) -> Void) {
        do {
            try auth.signOut()
            print("User logged out successfully")
            completion(.success(()))
        } catch let error {
            print("Logout failed: \(error.localizedDescription)")
            completion(.failure(.logoutFailed(error.localizedDescription)))
        }
    }
}
