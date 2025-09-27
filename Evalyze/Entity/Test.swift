//
//  Test.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

import Foundation

enum TestStatus {
    case upcoming
    case completed
}

struct Test {
    let id: String
    let title: String
    let description: String
    let questions: [Question]
    let duration: TimeInterval // в секундах
    let status: TestStatus
    let createdAt: Date
    let dueDate: Date?
    let completedAt: Date?
    let score: Int?
    let maxScore: Int
    
    init(
        id: String,
        title: String,
        description: String,
        questions: [Question],
        duration: TimeInterval,
        status: TestStatus,
        createdAt: Date = Date(),
        dueDate: Date? = nil,
        completedAt: Date? = nil,
        score: Int? = nil,
        maxScore: Int = 10
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.questions = questions
        self.duration = duration
        self.status = status
        self.createdAt = createdAt
        self.dueDate = dueDate
        self.completedAt = completedAt
        self.score = score
        self.maxScore = maxScore
    }
}

// MARK: - Mock Data
extension Test {
    static let mockUpcomingTests: [Test] = [
        Test(
            id: "test_1",
            title: "Математический анализ",
            description: "Контрольная работа по основам математического анализа",
            questions: [
                Question(id: 1, title: "Предел функции", prompt: "Найдите предел функции f(x) = (x² - 1)/(x - 1) при x → 1"),
                Question(id: 2, title: "Производная", prompt: "Найдите производную функции f(x) = x³ + 2x² - 5x + 1"),
                Question(id: 3, title: "Интеграл", prompt: "Вычислите интеграл ∫(2x + 3)dx от 0 до 2")
            ],
            duration: 3600, // 1 час
            status: .upcoming,
            dueDate: Calendar.current.date(byAdding: .day, value: 3, to: Date())
        ),
        Test(
            id: "test_2",
            title: "Программирование на Swift",
            description: "Практическое задание по основам программирования на Swift",
            questions: [
                Question(id: 4, title: "Классы и объекты", prompt: "Создайте класс Person с свойствами name и age"),
                Question(id: 5, title: "Протоколы", prompt: "Объясните разницу между протоколом и классом в Swift"),
                Question(id: 6, title: "Обработка ошибок", prompt: "Покажите пример использования do-catch блока")
            ],
            duration: 5400, // 1.5 часа
            status: .upcoming,
            dueDate: Calendar.current.date(byAdding: .day, value: 7, to: Date())
        ),
        Test(
            id: "test_3",
            title: "Алгоритмы и структуры данных",
            description: "Тест по основным алгоритмам сортировки и поиска",
            questions: [
                Question(id: 7, title: "Сортировка", prompt: "Опишите алгоритм быстрой сортировки"),
                Question(id: 8, title: "Поиск", prompt: "В чем разница между линейным и бинарным поиском?"),
                Question(id: 9, title: "Сложность", prompt: "Какая временная сложность у алгоритма пузырьковой сортировки?")
            ],
            duration: 2700, // 45 минут
            status: .upcoming,
            dueDate: Calendar.current.date(byAdding: .day, value: 5, to: Date())
        )
    ]
    
    static let mockCompletedTests: [Test] = [
        Test(
            id: "test_4",
            title: "Основы информатики",
            description: "Итоговый тест по основам информатики",
            questions: [
                Question(id: 10, title: "Архитектура компьютера", prompt: "Назовите основные компоненты компьютера"),
                Question(id: 11, title: "Операционные системы", prompt: "Что такое процесс в операционной системе?")
            ],
            duration: 1800, // 30 минут
            status: .completed,
            completedAt: Calendar.current.date(byAdding: .day, value: -2, to: Date()),
            score: 8,
            maxScore: 10
        ),
        Test(
            id: "test_5",
            title: "Базы данных",
            description: "Контрольная работа по SQL и реляционным базам данных",
            questions: [
                Question(id: 12, title: "SQL запросы", prompt: "Напишите запрос для выборки всех пользователей старше 18 лет"),
                Question(id: 13, title: "Нормализация", prompt: "Объясните первую нормальную форму"),
                Question(id: 14, title: "Индексы", prompt: "Зачем нужны индексы в базе данных?")
            ],
            duration: 2400, // 40 минут
            status: .completed,
            completedAt: Calendar.current.date(byAdding: .day, value: -5, to: Date()),
            score: 9,
            maxScore: 10
        ),
        Test(
            id: "test_6",
            title: "Веб-разработка",
            description: "Практическое задание по HTML, CSS и JavaScript",
            questions: [
                Question(id: 15, title: "HTML", prompt: "Создайте форму для регистрации пользователя"),
                Question(id: 16, title: "CSS", prompt: "Как центрировать элемент по горизонтали и вертикали?"),
                Question(id: 17, title: "JavaScript", prompt: "В чем разница между let, const и var?")
            ],
            duration: 3600, // 1 час
            status: .completed,
            completedAt: Calendar.current.date(byAdding: .day, value: -10, to: Date()),
            score: 7,
            maxScore: 10
        )
    ]
}
