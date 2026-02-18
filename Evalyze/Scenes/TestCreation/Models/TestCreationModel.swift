//
//  TestCreationModel.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

struct TestCreationModel {
    var title: String
    var description: String
    var selectedGroup: String?
    var selectedQuestions: [Question]
    var duration: TimeInterval // в секундах
    var startDate: Date?
    
    init() {
        self.title = ""
        self.description = ""
        self.selectedGroup = nil
        self.selectedQuestions = []
        self.duration = 3600 // 1 час по умолчанию
        self.startDate = nil
    }
    
    var isValid: Bool {
        return !title.isEmpty && 
               !description.isEmpty && 
               selectedGroup != nil && 
               !selectedQuestions.isEmpty
    }
}

