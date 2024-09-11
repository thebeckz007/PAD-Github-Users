//
//  GithubUserListScreenModel.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//
//

import Foundation
import Combine

// MARK: Protocol GithubUserListScreenModelprotocol
/// protocol GithubUserListScreenModelprotocol
protocol GithubUserListScreenModelprotocol: BaseModelProtocol {
    /// getGithubUserList function
    /// - Parameter since: the starting Id of Github user for querying
    /// - Parameter numberOfPage: number of users per querying
    /// - Returns: Puslisher<[UserEntity], Error>
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[UserEntity], Error>
}

// MARK: struct GithubUserListScreenModel
/// struct GithubUserListScreenModel
struct GithubUserListScreenModel: GithubUserListScreenModelprotocol {
    /// githubAPI as GithubUserListAPIPProtocol
    private let githubAPI: GithubUserListAPIPProtocol
    
    /// Initialize function
    init(githubAPI: GithubUserListAPIPProtocol) {
        self.githubAPI = githubAPI
    }
    
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[UserEntity], Error> {
        githubAPI.getGithubUserList(since: since, numberOfPage: numberOfPage)
            .map({ users in
                // transform GithubUser list into UserEntity list
                users.map { UserEntity.init(githubUserAPI: $0)}
            })
            .eraseToAnyPublisher()
    }
}
