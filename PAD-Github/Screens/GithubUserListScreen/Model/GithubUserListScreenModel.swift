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
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[UserEntity], Error>
}

// MARK: struct GithubUserListScreenModel
/// struct GithubUserListScreenModel
struct GithubUserListScreenModel: GithubUserListScreenModelprotocol {
    let githubAPI: GithubUserListAPIPProtocol
    
    init(githubAPI: GithubUserListAPIPProtocol) {
        self.githubAPI = githubAPI
    }
    
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[UserEntity], Error> {
        githubAPI.getGithubUserList(since: since, numberOfPage: numberOfPage)
            .map({ users in
                users.map { UserEntity.init(githubUserAPI: $0)}
            })
            .eraseToAnyPublisher()
    }
}
