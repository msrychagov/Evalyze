//
//  Group.swift
//  Evalyze
//
//  Created by Артём on 26.09.2025.
//

import Foundation
import FirebaseFirestore

struct Group: Codable {
    let id: String
    let name: String
    let createdBy: String // ID преподавателя
    let createdAt: Date
    let isActive: Bool
    
    // Вычисляемые свойства
    var displayName: String {
        return name.uppercased()
    }
    
    // Инициализатор для создания новой группы
    init(name: String, createdBy: String) {
        self.id = UUID().uuidString
        self.name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        self.createdBy = createdBy
        self.createdAt = Date()
        self.isActive = true
    }
    
    // Инициализатор для данных из Firestore
    init(id: String, name: String, createdBy: String, createdAt: Date, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.isActive = isActive
    }
    
    // Преобразование в словарь для Firestore
    var dictionary: [String: Any] {
        return [
            "id": id,
            "name": name,
            "createdBy": createdBy,
            "createdAt": Timestamp(date: createdAt),
            "isActive": isActive
        ]
    }
}

// MARK: - Group Extensions
extension Group {
    static func from(dictionary: [String: Any], documentId: String) -> Group? {
        guard let name = dictionary["name"] as? String,
              let createdBy = dictionary["createdBy"] as? String,
              let createdAtTimestamp = dictionary["createdAt"] as? Timestamp else {
            return nil
        }
        
        let isActive = dictionary["isActive"] as? Bool ?? true
        
        return Group(
            id: documentId,
            name: name,
            createdBy: createdBy,
            createdAt: createdAtTimestamp.dateValue(),
            isActive: isActive
        )
    }
}

// MARK: - Equatable
extension Group: Equatable {
    static func == (lhs: Group, rhs: Group) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Hashable
extension Group: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
