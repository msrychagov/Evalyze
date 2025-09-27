//
//  TestService.swift
//  Evalyze
//
//  Created by Assistant on 27.09.2025.
//

import Foundation
import FirebaseFirestore

enum TestError: Error, LocalizedError {
    case createFailed(String)
    case fetchFailed(String)
    case updateFailed(String)
    case unknownError

    var errorDescription: String? {
        switch self {
        case .createFailed(let message): return "Ошибка создания теста: \(message)"
        case .fetchFailed(let message): return "Ошибка загрузки тестов: \(message)"
        case .updateFailed(let message): return "Ошибка обновления теста: \(message)"
        case .unknownError: return "Неизвестная ошибка при работе с тестами"
        }
    }
}

protocol TestServiceProtocol {
    func createTest(_ test: Test, completion: @escaping (Result<Test, TestError>) -> Void)
    func getAllTests(completion: @escaping (Result<[Test], TestError>) -> Void)
    func getTestsCreatedBy(teacherId: String, completion: @escaping (Result<[Test], TestError>) -> Void)
    func updateTest(_ test: Test, completion: @escaping (Result<Test, TestError>) -> Void)
}

final class TestService: TestServiceProtocol {
    private let db = Firestore.firestore()
    private let testsCollection = "tests"
    
    func createTest(_ test: Test, completion: @escaping (Result<Test, TestError>) -> Void) {
        print("💾 Creating test in Firebase: \(test.title)")
        
        let testData: [String: Any] = [
            "title": test.title,
            "description": test.description,
            "questions": test.questions.map { $0.dictionary },
            "duration": test.duration,
            "status": test.status.rawValue,
            "createdBy": test.createdBy,
            "createdAt": FieldValue.serverTimestamp(),
            "dueDate": test.dueDate ?? NSNull(),
            "completedAt": test.completedAt ?? NSNull(),
            "score": test.score ?? NSNull(),
            "maxScore": test.maxScore
        ]
        
        db.collection(testsCollection).addDocument(data: testData) { error in
            if let error = error {
                print("❌ Failed to create test: \(error.localizedDescription)")
                completion(.failure(.createFailed(error.localizedDescription)))
            } else {
                print("✅ Test created successfully")
                completion(.success(test))
            }
        }
    }
    
    func getAllTests(completion: @escaping (Result<[Test], TestError>) -> Void) {
        print("📄 Fetching all tests from Firebase")
        
        db.collection(testsCollection)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Failed to fetch tests: \(error.localizedDescription)")
                    completion(.failure(.fetchFailed(error.localizedDescription)))
                    return
                }
                
                let tests = snapshot?.documents.compactMap { document -> Test? in
                    self.parseTestFromDocument(document)
                } ?? []
                
                print("✅ Fetched \(tests.count) tests")
                completion(.success(tests))
            }
    }
    
    func getTestsCreatedBy(teacherId: String, completion: @escaping (Result<[Test], TestError>) -> Void) {
        print("👨‍🏫 Fetching tests created by teacher: \(teacherId)")
        
        db.collection(testsCollection)
            .whereField("createdBy", isEqualTo: teacherId)
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Failed to fetch teacher tests: \(error.localizedDescription)")
                    completion(.failure(.fetchFailed(error.localizedDescription)))
                    return
                }
                
                let tests = snapshot?.documents.compactMap { document -> Test? in
                    self.parseTestFromDocument(document)
                } ?? []
                
                print("✅ Fetched \(tests.count) tests for teacher")
                completion(.success(tests))
            }
    }
    
    func updateTest(_ test: Test, completion: @escaping (Result<Test, TestError>) -> Void) {
        // TODO: Implement if needed
        completion(.failure(.unknownError))
    }
    
    // MARK: - Private Methods
    private func parseTestFromDocument(_ document: QueryDocumentSnapshot) -> Test? {
        let data = document.data()
        
        guard let title = data["title"] as? String,
              let description = data["description"] as? String,
              let questionsData = data["questions"] as? [[String: Any]],
              let duration = data["duration"] as? TimeInterval,
              let statusString = data["status"] as? String,
              let status = TestStatus(rawValue: statusString),
              let createdBy = data["createdBy"] as? String,
              let createdAtTimestamp = data["createdAt"] as? Timestamp,
              let maxScore = data["maxScore"] as? Int else {
            print("❌ Failed to parse test document: \(document.documentID)")
            return nil
        }
        
        // Parse questions
        let questions = questionsData.compactMap { questionData -> Question? in
            guard let category = questionData["category"] as? String,
                  let questionText = questionData["question"] as? String else {
                return nil
            }
            
            let createdAt = (questionData["createdAt"] as? Timestamp)?.dateValue() ?? Date()
            return Question(id: nil, category: category, question: questionText, createdAt: createdAt)
        }
        
        let dueDate = (data["dueDate"] as? Timestamp)?.dateValue()
        let completedAt = (data["completedAt"] as? Timestamp)?.dateValue()
        let score = data["score"] as? Int
        
        return Test(
            id: document.documentID,
            title: title,
            description: description,
            questions: questions,
            duration: duration,
            status: status,
            createdBy: createdBy,
            createdAt: createdAtTimestamp.dateValue(),
            dueDate: dueDate,
            completedAt: completedAt,
            score: score,
            maxScore: maxScore
        )
    }
}
