//
//  NetworkClient.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 27.09.2025.
//

import Foundation
//import SwiftKeychainWrapper

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

protocol NetworkClientProtocol {
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: U?,
        requiresAuth: Bool
    ) async throws -> T

    func requestWithoutResponse<U: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: U?,
        requiresAuth: Bool
    ) async throws
    
    func post<Request: Encodable, Response: Decodable>(
        url: String,
        body: Request,
        headers: [String: String]
    ) async throws -> Response
}

final class NetworkClient: NetworkClientProtocol {
    private let baseURL = "https://shedarena.ru"
    private var token = ""
    func request<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: U?,
        requiresAuth: Bool = true
    ) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if requiresAuth {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                request.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.decodingFailed(error)
            }
        }

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }

            switch httpResponse.statusCode {
            case 200 ... 299:
                do {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .custom { decoder in
                        let container = try decoder.singleValueContainer()
                        let dateString = try container.decode(String.self)

                        throw DecodingError.dataCorruptedError(in: container,
                                                               debugDescription: "Invalid date format: \(dateString)")
                    }

                    return try decoder.decode(T.self, from: data)
                } catch {
                    throw NetworkError.decodingFailed(error)
                }

            default:
                throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, error: nil)
            }
        } catch let error as NSError where error.code == NSURLErrorCancelled {
            throw NetworkError.requestCancelled
        } catch {
            print(error.localizedDescription)
            throw NetworkError.requestFailed(statusCode: (error as? URLError)?.errorCode ?? -1, error: nil)
        }
    }

    func requestWithoutResponse<U: Encodable>(
        endpoint: String,
        method: HTTPMethod,
        body: U?,
        requiresAuth: Bool = true
    ) async throws {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if requiresAuth {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        if let body = body {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                request.httpBody = try encoder.encode(body)
            } catch {
                throw NetworkError.encodingFailed(error)
            }
        }

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }

        switch httpResponse.statusCode {
        case 200 ... 299:
            return
        case 400, 401, 404, 409, 500:
            let error = try? JSONDecoder().decode(APIError.self, from: data)
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, error: error)
        default:
            throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, error: nil)
        }
    }
    
    func post<Request: Encodable, Response: Decodable>(
        url: String,
        body: Request,
        headers: [String: String]
    ) async throws -> Response {
        guard let url = URL(string: url) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Добавляем пользовательские заголовки
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        // Кодируем тело запроса
        do {
            let encoder = JSONEncoder()
            request.httpBody = try encoder.encode(body)
        } catch {
            throw NetworkError.encodingFailed(error)
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noData
            }
            
            switch httpResponse.statusCode {
            case 200...299:
                do {
                    let decoder = JSONDecoder()
                    return try decoder.decode(Response.self, from: data)
                } catch {
                    throw NetworkError.decodingFailed(error)
                }
            default:
                throw NetworkError.requestFailed(statusCode: httpResponse.statusCode, error: nil)
            }
        } catch let error as NSError where error.code == NSURLErrorCancelled {
            throw NetworkError.requestCancelled
        } catch {
            print(error.localizedDescription)
            throw NetworkError.requestFailed(statusCode: (error as? URLError)?.errorCode ?? -1, error: nil)
        }
    }
}
