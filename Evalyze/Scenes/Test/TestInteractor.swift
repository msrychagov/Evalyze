//
//  TestInteractor.swift
//  Evalyze
//
//  Created by Эльвира Матвеенко on 25.09.2025.
//

import Foundation

final class TestInteractor: TestInteractorInputProtocol {
    weak var output: TestInteractorOutputProtocol?

    func fetchIntroInfo() {
        let info = "Тест состоит из 10 вопросов про iOS. Ответы сохраняются автоматически. Удачи!"
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.output?.didLoadIntro(info)
        }
    }

    func fetchQuestions() {
        let questions = [
            Question(id: 1, title: "ARC", prompt: "Что такое ARC и как он управляет памятью в iOS?"),
            Question(id: 2, title: "Frame vs Bounds", prompt: "Объясните разницу между frame и bounds у UIView и когда что использовать."),
            Question(id: 3, title: "GCD", prompt: "Что такое Grand Central Dispatch? Примеры использования для фоновых задач и UI-обновлений."),
            Question(id: 4, title: "weak vs unowned", prompt: "Чем отличаются weak и unowned ссылки в Swift? Приведите примеры."),
            Question(id: 5, title: "App lifecycle", prompt: "Что происходит в AppDelegate/SceneDelegate при запуске приложения? Основные шаги и точки входа."),
            Question(id: 6, title: "ARC", prompt: "Что такое ARC и как он управляет памятью в iOS?"),
            Question(id: 7, title: "Frame vs Bounds", prompt: "Объясните разницу между frame и bounds у UIView и когда что использовать."),
            Question(id: 8, title: "GCD", prompt: "Что такое Grand Central Dispatch? Примеры использования для фоновых задач и UI-обновлений."),
            Question(id: 9, title: "weak vs unowned", prompt: "Чем отличаются weak и unowned ссылки в Swift? Приведите примеры."),
            Question(id: 10, title: "App lifecycle", prompt: "Что происходит в AppDelegate/SceneDelegate при запуске приложения? Основные шаги и точки входа.")
        ]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.output?.didLoadQuestions(questions)
        }
    }

    func submitAnswers(_ answers: [Int : String]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let result = TestResult(answers: answers)
            self.output?.didSubmit(result: result)
        }
    }
}
