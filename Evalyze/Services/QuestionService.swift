//
//  QuestionService.swift
//  Evalyze
//
//  Created by Assistant on 27.09.2025.
//

import Foundation
import FirebaseFirestore

enum QuestionError: Error, LocalizedError {
    case fetchFailed(String)
    case unknownError
    
    var errorDescription: String? {
        switch self {
        case .fetchFailed(let message):
            return "Ошибка загрузки вопросов: \(message)"
        case .unknownError:
            return "Неизвестная ошибка при работе с вопросами"
        }
    }
}

protocol QuestionServiceProtocol {
    func getAllQuestions(completion: @escaping (Result<[Question], QuestionError>) -> Void)
    func getQuestionsByCategory(_ category: String, completion: @escaping (Result<[Question], QuestionError>) -> Void)
}

final class QuestionService: QuestionServiceProtocol {
    private let db = Firestore.firestore()
    private let questionsCollection = "questions"
    
    func getAllQuestions(completion: @escaping (Result<[Question], QuestionError>) -> Void) {
        db.collection(questionsCollection).getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(.fetchFailed(error.localizedDescription)))
                return
            }
            
            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }
            
            let questions = documents.compactMap { document -> Question? in
                let data = document.data()
                guard let category = data["category"] as? String,
                      let question = data["question"] as? String,
                      let createdAtTimestamp = data["createdAt"] as? Timestamp else {
                    return nil
                }
                
                return Question(
                    id: document.documentID,
                    category: category,
                    question: question,
                    createdAt: createdAtTimestamp.dateValue()
                )
            }
            
            completion(.success(questions))
        }
    }
    
    func getQuestionsByCategory(_ category: String, completion: @escaping (Result<[Question], QuestionError>) -> Void) {
        db.collection(questionsCollection)
            .whereField("category", isEqualTo: category)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(.fetchFailed(error.localizedDescription)))
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion(.success([]))
                    return
                }
                
                let questions = documents.compactMap { document -> Question? in
                    let data = document.data()
                    guard let category = data["category"] as? String,
                          let question = data["question"] as? String,
                          let createdAtTimestamp = data["createdAt"] as? Timestamp else {
                        return nil
                    }
                    
                    return Question(
                        id: document.documentID,
                        category: category,
                        question: question,
                        createdAt: createdAtTimestamp.dateValue()
                    )
                }
                
                completion(.success(questions))
            }
    }
}
