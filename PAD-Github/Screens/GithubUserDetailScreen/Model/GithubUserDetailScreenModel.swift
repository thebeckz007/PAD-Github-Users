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
    func getGithubUserDetail(userID: String) -> AnyPublisher<UserEntity, Error>
}

// MARK: struct GithubUserDetailScreenModel
/// struct GithubUserDetailScreenModel
struct GithubUserDetailScreenModel: GithubUserDetailScreenModelprotocol {
    let githubAPI: GithubUserDetailAPIPProtocol
    
    init(githubAPI: GithubUserDetailAPIPProtocol) {
        self.githubAPI = githubAPI
    }
    
    func getGithubUserDetail(userID: String) -> AnyPublisher<UserEntity, Error> {
        githubAPI.getGithubUserDetail(userID: userID)
            .map{ UserEntity(githubUserAPI: $0) }
            .eraseToAnyPublisher()
    }
}
