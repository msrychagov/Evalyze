//
//  APIError.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//


import Foundation

struct APIError: Decodable, LocalizedError {
    let code: String
    let message: String

    var errorDescription: String? {
        message
    }
}

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case unauthorized
    case decodingFailed(Error)
    case encodingFailed(Error)
    case requestFailed(statusCode: Int, error: APIError?)
    case requestCancelled
    case invalidResponse

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Неверный URL запроса"
        case .noData:
            return "Данные не получены"
        case .unauthorized:
            return "Ошибка авторизации. Проверьте токен."
        case .decodingFailed:
            return "Ошибка декодирования ответа"
        case .encodingFailed:
            return "Ошибка сериализации запроса"
        case .requestCancelled:
            return "Запрос был отменен"
        case .invalidResponse:
            return "Неверный формат ответа"
        case let .requestFailed(statusCode, error):
            switch statusCode {
            case 400:
                return error?.message ?? "Некорректные данные или неверный формат ID картинки"
            case 401:
                return error?.message ?? "Неавторизованный доступ"
            case 404:
                return error?.message ?? "Ресурс не найден"
            case 409:
                return error?.message ?? "Конфликт"
            case 500:
                return error?.message ?? "Внутренняя ошибка сервера"
            default:
                return error?.message ?? "Ошибка запроса: \(statusCode)"
            }
        }
    }
}
