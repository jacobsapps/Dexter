//
//  URLSession+Extensions.swift
//  Dexter
//
//  Created by Jacob Bartlett on 23/11/2021.
//

import Combine
import Foundation

extension URLSession {
    
    enum NetworkingError: Error, LocalizedError {
        case read(_ description: String, path: String?, method: String?)
        case write(_ description: String, path: String?, method: String?)

        public var errorDescription: String? {
            switch self {
            case .read(let description, let path, let method):
                return NSLocalizedString("\(method ?? "Network") error \(path ?? "path"): \(description)", comment: "Read error")
            case .write(let description, let path, let method):
                return NSLocalizedString("\(method ?? "Network") error at \(path ?? "path"): \(description)", comment: "Write error")
            }
        }
    }
    
    enum NetworkError: Error {
        case invalidURL
        case notAuthenticated(description: String)
        case unsuccessfulResponse // (description: String)
        case unknownError(description: String)
        case decodingError(description: String)
    }

    func readPublisher<T: Decodable>(_ request: URLRequest,
                                     responseType: T.Type = T.self,
                                     decoder: JSONDecoder = JSONDecoder()) -> AnyPublisher<T, Error> {
        dataTaskPublisher(for: request)
            .tryMap { element -> Data in
                guard let response = element.response as? HTTPURLResponse,
                      response.isSuccessful else {
                          throw NetworkingError.read(element.data.utf8 ?? "Unknown", path: request.url?.path, method: request.httpMethod)
                      }
                return element.data
            }
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func writePublisher(_ request: URLRequest, eraseCache: Bool = true) -> AnyPublisher<Void, Error> {
        dataTaskPublisher(for: request)
            .tryMap { element -> Void in
                guard let response = element.response as? HTTPURLResponse,
                      response.isSuccessful else {
                          throw NetworkingError.write(element.data.utf8 ?? "Unknown", path: request.url?.path, method: request.httpMethod)
                      }
                return ()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

public extension Data {
    
    var utf8: String? {
        String(data: self, encoding: .utf8)
    }
}
