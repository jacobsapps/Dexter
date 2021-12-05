//
//  URLRequest+Extensions.swift
//  Dexter
//
//  Created by Jacob Bartlett on 23/11/2021.
//

import Foundation

extension URLRequest {
    
    enum HTTPMethod {
        case get
        case post(Data? = nil)
        case put(Data? = nil)
        case delete
        
        var stringValue: String {
            switch self {
            case .get:
                return "GET"
            case .post:
                return "POST"
            case .put:
                return "PUT"
            case .delete:
                return "DELETE"
            }
        }

        var data: Data? {
            switch self {
            case .get, .delete:
                return nil
            case .put(let param):
                return param
            case .post(let param):
                return param
            }
        }
    }
    
    /// Constructs an authenticated URLRequest with a HTTP method set for a given URL.
    ///
    /// - Parameters:
    ///     - url: A valid URL for the requested API endpoint
    ///     - method: The HTTP method used to create the request, defined in the enum in this file.
    ///     - authToken: The token used in the Authorization header to identify the user
    ///     - body: An optional parameter containing data to send to the server in PUT requests, POST requests, etc.
    ///
    init(_ url: URL, _ method: HTTPMethod, _ authToken: String? = nil) {
        self.init(url: url)

        httpMethod = method.stringValue
        
        if let authToken = authToken {
            addValue(authToken, forHTTPHeaderField: "Authorization")
        }
        if let body = method.data {
            addValue("application/json", forHTTPHeaderField: "Content-Type")
            httpBody = body
        }
    }
    
    func withHeader(authToken: String) -> URLRequest {
        var request = self
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        return request
    }
}
