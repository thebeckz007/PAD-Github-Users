//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Foundation
import Combine

// MARK: protocol GithubUserListAPIPProtocol
/// protocol GithubUserListAPIPProtocol
/// All apis of github user list
protocol GithubUserListAPIPProtocol {
    /// getGithubUserList function
    /// - Parameter since: the starting Id of Github user for querying
    /// - Parameter numberOfPage: number of users per querying
    /// - Returns: Publisher<[GithubUser], Error>
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[GithubUser], Error>
}

// MARK: protocol GithubUserDetailAPIPProtocol
/// protocol GithubUserDetailAPIPProtocol
/// All apis of github user detail
protocol GithubUserDetailAPIPProtocol {
    /// getGithubUserDetail function
    /// - Parameter userID: The id of Github user for querying
    /// - Returns: Publisher<GithubUser, Error>
    func getGithubUserDetail(userID: String) -> AnyPublisher<GithubUser, Error>
}

// MARK: protocol GithubAPIPProtocol
/// protocol GithubAPIPProtocol
/// All apis of github user
protocol GithubAPIPProtocol: GithubUserListAPIPProtocol, GithubUserDetailAPIPProtocol {
    
}

// MARK: struct GithubAPI
/// struct GithubAPI
struct GithubAPI: GithubAPIPProtocol {
    /// contentType of request as String
    let contentType: String
    
    /// base domain server of request as URL
    let baseURL: URL
    
    /// session of network as URLSession
    let networkSession: URLSession
    
    /// Initalize method
    /// - Parameter baseURL: base domain server as URL
    /// - Parameter networkSession: session of network as URLSession
    /// - Parameter contenType: content format of response as string. Its default value  is "application/json; charset=utf-8"
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

// MARK: enum HTTPError
/// enum HTTPError
enum HTTPError: LocalizedError {
    case statusCode
}
