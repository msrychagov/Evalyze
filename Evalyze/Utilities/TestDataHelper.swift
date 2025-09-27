//
//  TestDataHelper.swift
//  Evalyze
//
//  Created by Артём on 26.09.2025.
//

import Foundation
import FirebaseAuth

final class TestDataHelper {
    static func createTestGroups() {
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        
        let groupService = GroupService()
        let testGroups = [
            "ИВТ-21", "ИВТ-22", "ИВТ-23",
            "ПИ-21", "ПИ-22", "ПИ-23",
            "ИБ-21", "ИБ-22", "ИБ-23"
        ]
        
        for groupName in testGroups {
            groupService.createGroup(name: groupName, createdBy: currentUser.uid) { result in
                switch result {
                case .success(_):
                    break
                case .failure(let error):
                    if !error.localizedDescription.contains("уже существует") {
                        print("Failed to create group \(groupName): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    static func checkAndCreateTestGroups() {
        let groupService = GroupService()
        
        groupService.getAllActiveGroups { result in
            switch result {
            case .success(let groups):
                if groups.isEmpty {
                    createTestGroups()
                }
            case .failure(_):
                break
            }
        }
    }
}
