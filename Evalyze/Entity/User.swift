//
//  User.swift
//  Evalyze
//
//  Created by Артём on 25.09.2025.
//

import Foundation

enum UserRole: String, CaseIterable, Codable {
    case student
    case teacher
}

struct User: Codable {
    let id: String
    let email: String
    let fullName: String
    let role: UserRole
    let groups: [String]
    let createdAt: Date
    
    var isStudent: Bool {
        return role == .student
    }
    
    var isTeacher: Bool {
        return role == .teacher
    }
    
    var studentGroup: String? {
        return isStudent ? groups.first : nil
    }
    
    var teacherGroups: [String] {
        return isTeacher ? groups : []
    }
}
