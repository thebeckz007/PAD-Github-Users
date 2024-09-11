//
//  GithubUserDetailScreenModel.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//
//

import Foundation
import Combine

// MARK: Protocol GithubUserDetailScreenModelprotocol
/// protocol GithubUserDetailScreenModelprotocol
protocol GithubUserDetailScreenModelprotocol: BaseModelProtocol {
    /// getGithubUserDetail function
    /// - Parameter userID: The id of Github user for querying
    /// - Returns: Publisher<GithubUser, Error>
    func getGithubUserDetail(userID: String) -> AnyPublisher<UserEntity, Error>
}

// MARK: struct GithubUserDetailScreenModel
/// struct GithubUserDetailScreenModel
struct GithubUserDetailScreenModel: GithubUserDetailScreenModelprotocol {
    /// githubAPI as GithubUserDetailAPIPProtocol
    private let githubAPI: GithubUserDetailAPIPProtocol
    
    /// Initialize function
    init(githubAPI: GithubUserDetailAPIPProtocol) {
        self.githubAPI = githubAPI
    }
    
    func getGithubUserDetail(userID: String) -> AnyPublisher<UserEntity, Error> {
        githubAPI.getGithubUserDetail(userID: userID)
            .map{ UserEntity(githubUserAPI: $0) }
            .eraseToAnyPublisher()
    }
}
