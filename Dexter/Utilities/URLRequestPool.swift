//
//  URLRequestPool.swift
//  Dexter
//
//  Created by Jacob Bartlett on 23/11/2021.
//

import Combine
import Foundation

/// Allows simple, type-safe access to URL requests
///
/// - Parameters:
///     - request: Returns a URL request for the enum case
///
protocol URLRequestPool {
    var endpoint: String { get }
    func method(data: Data?) -> URLRequest.HTTPMethod
    func request(data: Data?) -> AnyPublisher<URLRequest, Error>
}

extension URLRequestPool {
    
    private var baseURL: URL {
        URL(staticString: "https://pokeapi.co/api/v2/")
    }
    
    func request(data: Data? = nil) -> AnyPublisher<URLRequest, Error> {
        guard let url = URL(string: baseURL.absoluteString + endpoint) else {
            return Fail(error: URLSession.NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        return authenticatedRequest(from: URLRequest(url, method(data: data)))
    }
    
    private var authTokenPublisher: AnyPublisher<String, Error> {
        Just("your_auth_token")
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    private func authenticatedRequest(from request: URLRequest) -> AnyPublisher<URLRequest, Error> {
        authTokenPublisher
            .map { request.withHeader(authToken: $0) }
            .mapError { URLSession.NetworkError.notAuthenticated(description: $0.localizedDescription) }
            .eraseToAnyPublisher()
    }
}
