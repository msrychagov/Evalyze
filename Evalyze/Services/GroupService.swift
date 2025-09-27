//
//  GroupService.swift
//  Evalyze
//
//  Created by Артём on 26.09.2025.
//

import Foundation
import FirebaseFirestore

protocol GroupServiceProtocol {
    func createGroup(name: String, createdBy: String, completion: @escaping (Result<Group, GroupError>) -> Void)
    func getAllActiveGroups(completion: @escaping (Result<[Group], GroupError>) -> Void)
    func getGroupsCreatedBy(teacherId: String, completion: @escaping (Result<[Group], GroupError>) -> Void)
    func deleteGroup(groupId: String, completion: @escaping (Result<Void, GroupError>) -> Void)
    func updateGroup(_ group: Group, completion: @escaping (Result<Group, GroupError>) -> Void)
}

enum GroupError: Error, LocalizedError {
    case groupAlreadyExists
    case groupNotFound
    case invalidGroupName
    case networkError(String)
    case permissionDenied
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .groupAlreadyExists:
            return "Группа с таким названием уже существует"
        case .groupNotFound:
            return "Группа не найдена"
        case .invalidGroupName:
            return "Некорректное название группы"
        case .networkError(let message):
            return "Ошибка сети: \(message)"
        case .permissionDenied:
            return "Недостаточно прав для выполнения операции"
        case .unknownError:
            return "Неизвестная ошибка"
        }
    }
}

final class GroupService: GroupServiceProtocol {
    private let db = Firestore.firestore()
    private let groupsCollection = "groups"
    
    func createGroup(name: String, createdBy: String, completion: @escaping (Result<Group, GroupError>) -> Void) {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        // Проверяем корректность названия
        guard !trimmedName.isEmpty, trimmedName.count >= 2 else {
            completion(.failure(.invalidGroupName))
            return
        }
        
        // Проверяем, не существует ли уже группа с таким названием
        checkGroupExists(name: trimmedName) { [weak self] exists in
            if exists {
                completion(.failure(.groupAlreadyExists))
                return
            }
            
            // Создаем новую группу
            let group = Group(name: trimmedName, createdBy: createdBy)
            
            self?.db.collection(self?.groupsCollection ?? "groups")
                .document(group.id)
                .setData(group.dictionary) { error in
                    if let error = error {
                        completion(.failure(.networkError(error.localizedDescription)))
                    } else {
                        print("Group created successfully: \(group.name)")
                        completion(.success(group))
                    }
                }
        }
    }
    
    func getAllActiveGroups(completion: @escaping (Result<[Group], GroupError>) -> Void) {
        db.collection(groupsCollection)
            .whereField("isActive", isEqualTo: true)
            .order(by: "name")
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                let groups = snapshot?.documents.compactMap { document in
                    Group.from(dictionary: document.data(), documentId: document.documentID)
                } ?? []
                completion(.success(groups))
            }
    }
    
    func getGroupsCreatedBy(teacherId: String, completion: @escaping (Result<[Group], GroupError>) -> Void) {
        db.collection(groupsCollection)
            .whereField("createdBy", isEqualTo: teacherId)
            .whereField("isActive", isEqualTo: true)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                let groups = snapshot?.documents.compactMap { document in
                    Group.from(dictionary: document.data(), documentId: document.documentID)
                } ?? []
                
                print("👨‍🏫 Loaded \(groups.count) groups for teacher: \(teacherId)")
                completion(.success(groups))
            }
    }
    
    func deleteGroup(groupId: String, completion: @escaping (Result<Void, GroupError>) -> Void) {
        // Мягкое удаление - помечаем как неактивную
        db.collection(groupsCollection)
            .document(groupId)
            .updateData(["isActive": false]) { error in
                if let error = error {
                    completion(.failure(.networkError(error.localizedDescription)))
                } else {
                    print("🗑️ Group marked as inactive: \(groupId)")
                    completion(.success(()))
                }
            }
    }
    
    func updateGroup(_ group: Group, completion: @escaping (Result<Group, GroupError>) -> Void) {
        db.collection(groupsCollection)
            .document(group.id)
            .setData(group.dictionary, merge: true) { error in
                if let error = error {
                    completion(.failure(.networkError(error.localizedDescription)))
                } else {
                    print("Group updated successfully: \(group.name)")
                    completion(.success(group))
                }
            }
    }
    
    // MARK: - Private Methods
    private func checkGroupExists(name: String, completion: @escaping (Bool) -> Void) {
        db.collection(groupsCollection)
            .whereField("name", isEqualTo: name)
            .whereField("isActive", isEqualTo: true)
            .limit(to: 1)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error checking group existence: \(error)")
                    completion(false)
                    return
                }
                
                let exists = !(snapshot?.documents.isEmpty ?? true)
                completion(exists)
            }
    }
}
