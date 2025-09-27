//
//  AuthenticationInteractor.swift
//  Evalyze
//
//  Created by Артём on 25.09.2025.
//

import Foundation
import UIKit

final class AuthenticationInteractor {
    // MARK: - Properties
    weak var presenter: AuthenticationInteractorOutputProtocol?
    
    // MARK: - Private Properties
    private let authService: AuthenticationServiceProtocol
    private let validationService: ValidationServiceProtocol
    private let groupService: GroupServiceProtocol
    
    // MARK: - Init
    init(
        authService: AuthenticationServiceProtocol = AuthenticationService(),
        validationService: ValidationServiceProtocol = ValidationService(),
        groupService: GroupServiceProtocol = GroupService()
    ) {
        self.authService = authService
        self.validationService = validationService
        self.groupService = groupService
    }
}

// MARK: - AuthenticationInteractorProtocol
extension AuthenticationInteractor: AuthenticationInteractorProtocol {
    func login(email: String, password: String) {
        guard validateEmail(email) else {
            presenter?.loginDidFail(error: .invalidEmail)
            return
        }
        
        guard validatePassword(password) else {
            presenter?.loginDidFail(error: .invalidPassword)
            return
        }
        
        let request = LoginRequest(email: email, password: password)
        
        authService.login(request: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    self?.presenter?.loginDidSucceed(user: user)
                case .failure(let error):
                    self?.presenter?.loginDidFail(error: error)
                }
            }
        }
    }
    
    func register(name: String, email: String, password: String, role: UserRole, groups: [String]) {
        guard validateName(name) else {
            presenter?.registrationDidFail(error: .invalidName)
            return
        }
        
        guard validationService.isValidEmail(email, for: role) else {
            if role == .student {
                presenter?.registrationDidFail(error: AuthenticationError.invalidStudentEmail)
            } else {
                presenter?.registrationDidFail(error: AuthenticationError.invalidTeacherEmail)
            }
            return
        }
        
        guard validatePassword(password) else {
            presenter?.registrationDidFail(error: .invalidPassword)
            return
        }
        
        guard !groups.isEmpty else {
            presenter?.registrationDidFail(error: .emptyGroups)
            return
        }
        
        let request = RegistrationRequest(
            name: name,
            email: email,
            password: password,
            role: role,
            groups: groups
        )
        
        authService.register(request: request) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    if user.role == .teacher && !user.groups.isEmpty {
                        self?.createGroupsForTeacher(groups: user.groups, teacherId: user.id, user: user)
                    } else {
                        self?.presenter?.registrationDidSucceed(user: user)
                    }
                case .failure(let error):
                    self?.presenter?.registrationDidFail(error: error)
                }
            }
        }
    }
    
    func validateEmail(_ email: String) -> Bool {
        return validationService.isValidEmail(email)
    }
    
    func validatePassword(_ password: String) -> Bool {
        return validationService.isValidPassword(password)
    }
    
    func validateName(_ name: String) -> Bool {
        return validationService.isValidName(name)
    }
    
    func loadAvailableGroups() {
        groupService.getAllActiveGroups { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let groups):
                    self?.presenter?.groupsDidLoad(groups)
                case .failure(let error):
                    self?.presenter?.groupsDidFailToLoad(error: error)
                }
            }
        }
    }
    
    func createGroup(name: String, createdBy: String) {
        groupService.createGroup(name: name, createdBy: createdBy) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let group):
                    self?.presenter?.groupDidCreate(group)
                case .failure(let error):
                    self?.presenter?.groupDidFailToCreate(error: error)
                }
            }
        }
    }
    
    // MARK: - Private Methods
    private func createGroupsForTeacher(groups: [String], teacherId: String, user: User) {
        let dispatchGroup = DispatchGroup()
        var createdGroupsCount = 0
        
        for groupName in groups {
            dispatchGroup.enter()
            
            groupService.createGroup(name: groupName, createdBy: teacherId) { result in
                switch result {
                case .success(_):
                    createdGroupsCount += 1
                case .failure(let error):
                    print("Failed to create group \(groupName): \(error.localizedDescription)")
                }
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if createdGroupsCount > 0 {
                print("Created \(createdGroupsCount) groups for teacher")
                self.loadAvailableGroups()
            }
            
            self.presenter?.registrationDidSucceed(user: user)
        }
    }
}

// MARK: - Services Protocols
protocol AuthenticationServiceProtocol {
    func login(request: LoginRequest, completion: @escaping (Result<User, AuthenticationError>) -> Void)
    func register(request: RegistrationRequest, completion: @escaping (Result<User, AuthenticationError>) -> Void)
}

protocol ValidationServiceProtocol {
    func isValidEmail(_ email: String) -> Bool
    func isValidEmail(_ email: String, for role: UserRole) -> Bool
    func isValidPassword(_ password: String) -> Bool
    func isValidName(_ name: String) -> Bool
}

// MARK: - Firebase Authentication Service
import FirebaseAuth
import FirebaseFirestore

final class AuthenticationService: AuthenticationServiceProtocol {
    private let auth = Auth.auth()
    private let db = Firestore.firestore()
    
    init() {
        // Firebase Auth service initialized
    }
    
    func login(request: LoginRequest, completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        auth.signIn(withEmail: request.email, password: request.password) { [weak self] authResult, error in
            if let error = error {
                print("Login failed: \(error.localizedDescription)")
                let authError = self?.mapFirebaseError(error) ?? .unknownError
                completion(.failure(authError))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(.unknownError))
                return
            }
            
            print("Login successful: \(firebaseUser.email ?? "unknown")")
            self?.fetchUserData(uid: firebaseUser.uid, completion: completion)
        }
    }
    
    func register(request: RegistrationRequest, completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        // Создаем пользователя в Firebase Auth
        auth.createUser(withEmail: request.email, password: request.password) { [weak self] authResult, error in
            if let error = error {
                print("Registration failed: \(error.localizedDescription)")
                let authError = self?.mapFirebaseError(error) ?? .unknownError
                completion(.failure(authError))
                return
            }
            
            guard let firebaseUser = authResult?.user else {
                completion(.failure(.unknownError))
                return
            }
            
            print("User registered: \(firebaseUser.email ?? "unknown")")
            
            let user = User(
                id: firebaseUser.uid,
                email: request.email,
                fullName: request.name,
                role: request.role,
                groups: request.groups,
                createdAt: Date()
            )
            
            self?.saveUserToFirestore(user: user, completion: completion)
        }
    }
    
    // MARK: - Private Methods
    private func fetchUserData(uid: String, completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        db.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                completion(.failure(.networkError(error.localizedDescription)))
                return
            }
            
            guard let data = snapshot?.data(),
                  let user = self.parseUserData(uid: uid, data: data) else {
                completion(.failure(.serverError("Не удалось загрузить данные пользователя")))
                return
            }
            
            completion(.success(user))
        }
    }
    
    private func saveUserToFirestore(user: User, completion: @escaping (Result<User, AuthenticationError>) -> Void) {
        let userData: [String: Any] = [
            "email": user.email,
            "fullName": user.fullName,
            "role": user.role.rawValue,
            "groups": user.groups,
            "createdAt": Timestamp(date: user.createdAt)
        ]
        
        db.collection("users").document(user.id).setData(userData) { error in
            if let error = error {
                print("Failed to save user: \(error.localizedDescription)")
                completion(.failure(.networkError(error.localizedDescription)))
            } else {
                print("User saved successfully")
                completion(.success(user))
            }
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
    
    private func mapFirebaseError(_ error: Error) -> AuthenticationError {
        guard let authError = error as NSError? else {
            return .unknownError
        }
        
        switch authError.code {
        case AuthErrorCode.invalidEmail.rawValue:
            return .invalidEmail
        case AuthErrorCode.weakPassword.rawValue:
            return .invalidPassword
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return .serverError("Пользователь с таким email уже существует")
        case AuthErrorCode.userNotFound.rawValue, AuthErrorCode.wrongPassword.rawValue:
            return .serverError("Неверный email или пароль")
        case AuthErrorCode.networkError.rawValue:
            return .networkError("Проблемы с интернет-соединением")
        default:
            return .serverError(authError.localizedDescription)
        }
    }
}

final class ValidationService: ValidationServiceProtocol {
    func isValidEmail(_ email: String) -> Bool {
        // Общая проверка на HSE email адреса
        let emailRegex = "^[A-Za-z0-9._%+-]+@(edu\\.hse\\.ru|hse\\.ru)$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    func isValidEmail(_ email: String, for role: UserRole) -> Bool {
        let emailLowercase = email.lowercased()
        
        switch role {
        case .student:
            // Студенты должны использовать @edu.hse.ru
            let studentEmailRegex = "^[A-Za-z0-9._%+-]+@edu\\.hse\\.ru$"
            let studentPredicate = NSPredicate(format: "SELF MATCHES %@", studentEmailRegex)
            return studentPredicate.evaluate(with: emailLowercase)
            
        case .teacher:
            // Преподаватели должны использовать @hse.ru
            let teacherEmailRegex = "^[A-Za-z0-9._%+-]+@hse\\.ru$"
            let teacherPredicate = NSPredicate(format: "SELF MATCHES %@", teacherEmailRegex)
            return teacherPredicate.evaluate(with: emailLowercase)
        }
    }
    
    func isValidPassword(_ password: String) -> Bool {
        return password.count >= 6
    }
    
    func isValidName(_ name: String) -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Проверяем минимальную длину и наличие пробела (ФИО)
        guard trimmedName.count >= 2 && trimmedName.contains(" ") else {
            return false
        }
        
        // Проверяем, что нет цифр
        let hasNumbers = trimmedName.rangeOfCharacter(from: .decimalDigits) != nil
        if hasNumbers {
            return false
        }
        
        // Проверяем, что содержит только буквы, пробелы и допустимые символы
        let allowedCharacters = CharacterSet.letters
            .union(.whitespaces)
            .union(CharacterSet(charactersIn: "-'"))  // Разрешаем дефисы и апострофы
        
        return trimmedName.rangeOfCharacter(from: allowedCharacters.inverted) == nil
    }
}

