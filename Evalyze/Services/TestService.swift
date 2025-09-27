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
    func markTestAsCompleted(testId: String, score: Int, completion: @escaping (Result<Void, TestError>) -> Void)
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
            "targetGroup": test.targetGroup,
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
    
    func markTestAsCompleted(testId: String, score: Int, completion: @escaping (Result<Void, TestError>) -> Void) {
        print("✅ Marking test as completed: \(testId) with score: \(score)")
        
        let updateData: [String: Any] = [
            "status": TestStatus.completed.rawValue,
            "completedAt": FieldValue.serverTimestamp(),
            "score": score
        ]
        
        db.collection(testsCollection).document(testId).updateData(updateData) { error in
            if let error = error {
                print("❌ Failed to mark test as completed: \(error.localizedDescription)")
                completion(.failure(.updateFailed(error.localizedDescription)))
            } else {
                print("✅ Test marked as completed successfully")
                completion(.success(()))
            }
        }
    }
    
    // MARK: - Private Methods
    private func parseTestFromDocument(_ document: QueryDocumentSnapshot) -> Test? {
        let data = document.data()
        
        print("🔍 Parsing test document: \(document.documentID)")
        print("📋 Document data keys: \(data.keys.sorted())")
        
        guard let title = data["title"] as? String else {
            print("❌ Missing title in document: \(document.documentID)")
            return nil
        }
        
        guard let description = data["description"] as? String else {
            print("❌ Missing description in document: \(document.documentID)")
            return nil
        }
        
        guard let questionsData = data["questions"] as? [[String: Any]] else {
            print("❌ Missing questions in document: \(document.documentID)")
            return nil
        }
        
        guard let duration = data["duration"] as? TimeInterval else {
            print("❌ Missing duration in document: \(document.documentID)")
            return nil
        }
        
        guard let statusString = data["status"] as? String else {
            print("❌ Missing status in document: \(document.documentID)")
            return nil
        }
        
        guard let status = TestStatus(rawValue: statusString) else {
            print("❌ Invalid status '\(statusString)' in document: \(document.documentID)")
            return nil
        }
        
        guard let createdBy = data["createdBy"] as? String else {
            print("❌ Missing createdBy in document: \(document.documentID)")
            return nil
        }
        
        guard let targetGroup = data["targetGroup"] as? String else {
            print("❌ Missing targetGroup in document: \(document.documentID)")
            return nil
        }
        
        guard let createdAtTimestamp = data["createdAt"] as? Timestamp else {
            print("❌ Missing createdAt in document: \(document.documentID)")
            return nil
        }
        
        guard let maxScore = data["maxScore"] as? Int else {
            print("❌ Missing maxScore in document: \(document.documentID)")
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
        
        let test = Test(
            id: document.documentID,
            title: title,
            description: description,
            questions: questions,
            duration: duration,
            status: status,
            createdBy: createdBy,
            targetGroup: targetGroup,
            createdAt: createdAtTimestamp.dateValue(),
            dueDate: dueDate,
            completedAt: completedAt,
            score: score,
            maxScore: maxScore
        )
        
        print("✅ Successfully parsed test: \(title) (status: \(status.rawValue))")
        return test
    }
}
