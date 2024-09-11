//
//  File.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import Combine

// MARK: class MockGithubUserListScreenModel
/// class MockGithubUserListScreenModel
/// A mocked GithubUserListScreenModelprotocol
class MockGithubUserListScreenModel: GithubUserListScreenModelprotocol {
    var userListPublisher: Result<[UserEntity], Error>!
    
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[UserEntity], Error> {
        userListPublisher.publisher.eraseToAnyPublisher()
    }
}
