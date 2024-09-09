//
//  File.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Combine

struct MockGithubUserDetailScreenModel: GithubUserDetailScreenModelprotocol {
    var userDetailPublisher: Result<UserEntity, Error>!
    
    func getGithubUserDetail(userID: String) -> AnyPublisher<UserEntity, Error> {
        userDetailPublisher.publisher.eraseToAnyPublisher()
    }
}
