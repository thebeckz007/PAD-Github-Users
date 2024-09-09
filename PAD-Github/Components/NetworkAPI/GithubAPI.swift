//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Foundation
import Combine

protocol GithubUserListAPIPProtocol {
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[GithubUser], Error>
}

protocol GithubUserDetailAPIPProtocol {
    func getGithubUserDetail(userID: String) -> AnyPublisher<GithubUser, Error>
}

protocol GithubAPIPProtocol: GithubUserListAPIPProtocol, GithubUserDetailAPIPProtocol {
    
}

struct GithubAPI: GithubAPIPProtocol {
    let contentType: String
    let baseURL: URL
    let networkSession: URLSession
    
    init(baseURL: URL, networkSession: URLSession, contentType: String = "application/json; charset=utf-8") {
        self.contentType = contentType
        self.baseURL = baseURL
        self.networkSession = networkSession
    }
    
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[GithubUser], Error> {
        let request = URLRequest(baseURL: baseURL, path: "/users", query: ["per_page" : "\(numberOfPage)", "since": "\(since)"], headers: ["Content-Type": contentType])
        
        return networkSession.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: [GithubUser].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getGithubUserDetail(userID: String) -> AnyPublisher<GithubUser, Error> {
        let request = URLRequest(baseURL: baseURL, path: "/users/\(userID)", headers: ["Content-Type": contentType])

        return networkSession.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    throw HTTPError.statusCode
                }
                return output.data
            }
            .decode(type: GithubUser.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

enum HTTPError: LocalizedError {
    case statusCode
}
