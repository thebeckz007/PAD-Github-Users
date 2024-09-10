//
//  File.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import Combine

class MockGithubAPI: GithubAPIPProtocol {
    var userListPublisher: Result<[GithubUser], Error>!
    var userDetailPublisher: Result<GithubUser, Error>!
    
    func getGithubUserList(since: UInt, numberOfPage: UInt) -> AnyPublisher<[GithubUser], Error> {
        userListPublisher.publisher.eraseToAnyPublisher()
    }
    
    func getGithubUserDetail(userID: String) -> AnyPublisher<GithubUser, Error> {
        userDetailPublisher.publisher.eraseToAnyPublisher()
    }
}
