//
//  StudentTestAnswerService.swift
//  Evalyze
//
//  Created by Assistant on 27.09.2025.
//

import Foundation
import FirebaseFirestore

enum StudentTestAnswerError: Error, LocalizedError {
    case saveFailed(String)
    case fetchFailed(String)
    case notFound
    case unknownError

    var errorDescription: String? {
        switch self {
        case .saveFailed(let message): return "Ошибка сохранения ответов: \(message)"
        case .fetchFailed(let message): return "Ошибка загрузки ответов: \(message)"
        case .notFound: return "Ответы не найдены"
        case .unknownError: return "Неизвестная ошибка при работе с ответами"
        }
    }
}

protocol StudentTestAnswerServiceProtocol {
    func saveStudentAnswers(_ answer: StudentTestAnswer, completion: @escaping (Result<Void, StudentTestAnswerError>) -> Void)
    func getStudentAnswers(for testId: String, studentId: String, completion: @escaping (Result<StudentTestAnswer, StudentTestAnswerError>) -> Void)
}

final class StudentTestAnswerService: StudentTestAnswerServiceProtocol {
    private let db = Firestore.firestore()
    private let answersCollection = "studentTestAnswers"
    
    func saveStudentAnswers(_ answer: StudentTestAnswer, completion: @escaping (Result<Void, StudentTestAnswerError>) -> Void) {
        print("💾 Saving student answers for test: \(answer.testId)")
        print("📊 Answer data: studentId=\(answer.studentId), answers=\(answer.answers), overallScore=\(answer.overallScore)")
        
        let answerData: [String: Any] = [
            "id": answer.id,
            "testId": answer.testId,
            "studentId": answer.studentId,
            "answers": answer.answers,
            "overallScore": answer.overallScore,
            "questionScores": answer.questionScores.map { [
                "questionId": $0.questionId,
                "score": $0.score,
                "feedback": $0.feedback
            ]},
            "feedback": answer.feedback,
            "completedAt": Timestamp(date: answer.completedAt)
        ]
        
        print("📝 Prepared data for Firebase: \(answerData)")
        
        db.collection(answersCollection).document(answer.id).setData(answerData) { error in
            if let error = error {
                print("❌ Failed to save student answers: \(error.localizedDescription)")
                completion(.failure(.saveFailed(error.localizedDescription)))
            } else {
                print("✅ Student answers saved successfully to Firebase")
                completion(.success(()))
            }
        }
    }
    
    func getStudentAnswers(for testId: String, studentId: String, completion: @escaping (Result<StudentTestAnswer, StudentTestAnswerError>) -> Void) {
        print("📄 Fetching student answers for test: \(testId), student: \(studentId)")
        
        db.collection(answersCollection)
            .whereField("testId", isEqualTo: testId)
            .whereField("studentId", isEqualTo: studentId)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Failed to fetch student answers: \(error.localizedDescription)")
                    completion(.failure(.fetchFailed(error.localizedDescription)))
                    return
                }
                
                guard let document = snapshot?.documents.first else {
                    print("❌ Student answers not found")
                    completion(.failure(.notFound))
                    return
                }
                
                do {
                    let answer = try self.parseStudentAnswerFromDocument(document)
                    print("✅ Student answers fetched successfully")
                    completion(.success(answer))
                } catch {
                    print("❌ Failed to parse student answers: \(error.localizedDescription)")
                    completion(.failure(.fetchFailed(error.localizedDescription)))
                }
            }
    }
    
    private func parseStudentAnswerFromDocument(_ document: QueryDocumentSnapshot) throws -> StudentTestAnswer {
        let data = document.data()
        
        guard let id = data["id"] as? String,
              let testId = data["testId"] as? String,
              let studentId = data["studentId"] as? String,
              let answers = data["answers"] as? [String: String],
              let overallScore = data["overallScore"] as? Double,
              let questionScoresData = data["questionScores"] as? [[String: Any]],
              let feedback = data["feedback"] as? String,
              let completedAtTimestamp = data["completedAt"] as? Timestamp else {
            throw StudentTestAnswerError.fetchFailed("Missing required fields")
        }
        
        let questionScores = questionScoresData.compactMap { scoreData -> QuestionScore? in
            guard let questionId = scoreData["questionId"] as? Int,
                  let score = scoreData["score"] as? Double,
                  let feedback = scoreData["feedback"] as? String else {
                return nil
            }
            return QuestionScore(questionId: questionId, score: score, feedback: feedback)
        }
        
        return StudentTestAnswer(
            testId: testId,
            studentId: studentId,
            answers: answers,
            overallScore: overallScore,
            questionScores: questionScores,
            feedback: feedback
        )
    }
}
