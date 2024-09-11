//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Foundation

/// Extension of URLRequest
/// Support to initialize URLRequest
public extension URLRequest {
    /// Initialize function
    /// - parameter method: method name of request as String. e.g: GET, POST, etc.
    /// - parameter baseURL: domain server of request as URL. e.g: https://api.github.com
    /// - parameter path: path of request as String
    /// - parameter query: parameter list of request as dictionary [parameter:  value]
    /// - parameter header: header of request as dictionary [key: value]
    /// - parameter body: body of request as data binary
    init( method: String = "GET", baseURL: URL, path: String, query: [String: String] = [:], headers: [String: String] = [:], body: Data? = nil)
    {
        self.init(
            method: method,
            baseURL: baseURL,
            path: path,
            query: query.map { URLQueryItem(name: $0.key, value: $0.value) },
            headers: headers,
            body: body
        )
    }

    private init( method: String = "GET", baseURL: URL, path: String, query: [URLQueryItem] = [], headers: [String: String] = [:], body: Data? = nil)
    {
        var url = URLComponents(string: baseURL.absoluteString + path)!
        if query.isEmpty == false {
            url.queryItems = query
        }
        self.init(url: url.url!)
        httpMethod = method
        headers.forEach { key, value in
            self.setValue(value, forHTTPHeaderField: key)
        }
        httpBody = body
    }
}
