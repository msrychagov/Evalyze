//
//  TestEvaluationService.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation

protocol TestEvaluationServiceProtocol {
    func evaluateTest(test: Test, studentAnswers: [Int: String]) async throws -> TestEvaluationResponse
}

class TestEvaluationService: TestEvaluationServiceProtocol {
    private let networkClient: NetworkClientProtocol
    private let apiKey = "sk-46b7350b1db04591814d87702d074643"
    private let baseURL = "https://api.deepseek.com/v1/chat/completions"
    
    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func evaluateTest(test: Test, studentAnswers: [Int: String]) async throws -> TestEvaluationResponse {
        print("🔍 Creating evaluation prompt for test: \(test.title)")
        let prompt = createTestEvaluationPrompt(test: test, studentAnswers: studentAnswers)
        print("📝 Prompt created, length: \(prompt.count) characters")
        
        let request = DeepSeekRequest(
            model: "deepseek-chat",
            messages: [
                DeepSeekMessage(role: "system", content: "Ты эксперт-преподаватель по программированию и информатике. Оценивай ответы студентов объективно и справедливо, давая конструктивную обратную связь."),
                DeepSeekMessage(role: "user", content: prompt)
            ],
            temperature: 0.3, // Низкая температура для более консистентной оценки
            maxTokens: 2000
        )
        
        print("🚀 Sending request to DeepSeek API...")
        let response: DeepSeekResponse = try await networkClient.post(
            url: baseURL,
            body: request,
            headers: createHeaders()
        )
        
        print("📥 Received response from DeepSeek")
        let content = response.choices.first?.message.content ?? ""
        print("📄 Response content: \(content)")
        
        return try parseTestEvaluationResponse(content)
    }
    
    private func createTestEvaluationPrompt(test: Test, studentAnswers: [Int: String]) -> String {
        var prompt = """
        Проанализируй ответы студента на тест и оцени каждый вопрос от 0 до 10 баллов, а также дай общую оценку. Верни ответ в формате JSON, как указано ниже.

        {
            "overall_score": число от 0 до 10,
            "question_scores": [
                {
                    "question_id": номер вопроса,
                    "score": число от 0 до 10,
                    "feedback": "краткий комментарий к ответу"
                }
            ],
            "feedback": "общий комментарий к работе студента"
        }

        Информация о тесте:
        Название: \(test.title)
        Описание: \(test.description)

        Вопросы и ответы студента:
        """
        
        for (index, question) in test.questions.enumerated() {
            let studentAnswer = studentAnswers[question.id] ?? "Ответ не предоставлен"
            prompt += """
            
            Вопрос \(index + 1) (ID: \(question.id)):
            Тема: \(question.title)
            Вопрос: \(question.prompt)
            Ответ студента: \(studentAnswer)
            """
        }
        
        prompt += """
        
        Критерии оценки:
        - 10 баллов: Полный, точный и развернутый ответ
        - 8-9 баллов: Правильный ответ с небольшими неточностями
        - 6-7 баллов: Частично правильный ответ
        - 4-5 баллов: Ответ с существенными ошибками, но есть понимание темы
        - 2-3 балла: Минимальное понимание темы
        - 0-1 балл: Неправильный ответ или отсутствие ответа

        Обратная связь должна быть:
        - Конструктивной и поддерживающей
        - Указывать на сильные стороны
        - Давать рекомендации по улучшению
        - Быть лаконичной (не более 30 слов на вопрос)

        Верни только JSON без дополнительного текста.
        """
        
        return prompt
    }
    
    private func createHeaders() -> [String: String] {
        return [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json"
        ]
    }
    
    private func parseTestEvaluationResponse(_ responseText: String) throws -> TestEvaluationResponse {
        // Очищаем ответ от возможных лишних символов
        let cleanedText = responseText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Ищем JSON в ответе
        guard let jsonStart = cleanedText.firstIndex(of: "{"),
              let jsonEnd = cleanedText.lastIndex(of: "}") else {
            throw NetworkError.invalidResponse
        }
        
        let jsonString = String(cleanedText[jsonStart...jsonEnd])
        
        do {
            let data = jsonString.data(using: .utf8) ?? Data()
            let response = try JSONDecoder().decode(TestEvaluationResponse.self, from: data)
            return response
        } catch {
            // Если не удалось распарсить, создаем fallback ответ
            return createFallbackResponse()
        }
    }
    
    private func createFallbackResponse() -> TestEvaluationResponse {
        return TestEvaluationResponse(
            overallScore: 0.0,
            questionScores: [],
            feedback: "Оценка временно недоступна. Попробуйте позже."
        )
    }
}
