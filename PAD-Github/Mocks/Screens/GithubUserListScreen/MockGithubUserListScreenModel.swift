//
//  File.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import Combine

struct MockGithubUserListScreenModel: GithubUserListScreenModelprotocol {
    var userListPublisher: Result<[UserEntity], Error>!
    
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[UserEntity], Error> {
        userListPublisher.publisher.eraseToAnyPublisher()
    }
}
