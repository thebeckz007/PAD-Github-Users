//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Foundation

public extension URLRequest {
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
