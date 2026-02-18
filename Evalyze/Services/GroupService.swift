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
        print("🔍 GroupService: Searching for groups created by teacher: '\(teacherId)'")
        
        // ВРЕМЕННО: получаем все активные группы для тестирования
        // TODO: вернуть фильтрацию по teacherId после создания индекса
        db.collection(groupsCollection)
            .whereField("isActive", isEqualTo: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ GroupService: Error fetching groups: \(error.localizedDescription)")
                    completion(.failure(.networkError(error.localizedDescription)))
                    return
                }
                
                print("📄 GroupService: Found \(snapshot?.documents.count ?? 0) documents")
                
                let groups: [Group] = snapshot?.documents.compactMap { document -> Group? in
                    let group = Group.from(dictionary: document.data(), documentId: document.documentID)
                    if let group = group {
                        print("  ✅ Group: '\(group.name)' (createdBy: '\(group.createdBy)')")
                    } else {
                        print("  ❌ Failed to parse document: \(document.documentID)")
                    }
                    return group
                } ?? []
                
                // Фильтруем группы по teacherId на клиенте
                let teacherGroups = groups.filter { $0.createdBy == teacherId }
                
                // Сортируем группы по дате создания (новые сначала)
                let sortedGroups = teacherGroups.sorted { $0.createdAt > $1.createdAt }
                
                print("👨‍🏫 Filtered \(teacherGroups.count) groups from \(groups.count) total for teacher: \(teacherId)")
                completion(.success(sortedGroups))
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
