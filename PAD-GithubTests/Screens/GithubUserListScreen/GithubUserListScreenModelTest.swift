//
//  GithubUserListScreenModel.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import XCTest
import Combine

final class GithubUserListScreenModelTest: XCTestCase {
    public var githubUserListModel: GithubUserListScreenModel!
    public var mockGithubAPI: MockGithubAPI!
    public var subscribers = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockGithubAPI = MockGithubAPI()
        githubUserListModel = GithubUserListScreenModel(githubAPI: mockGithubAPI)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        subscribers.removeAll()
    }

    func testLoadGitHubUsersSuccess() throws {
        let inputData = [
            MockGithubUser.user1,
            MockGithubUser.user2,
            MockGithubUser.user3,
            MockGithubUser.user4,
            MockGithubUser.user5]
        
        let outputData = [
            MockUserEntity.user1,
            MockUserEntity.user2,
            MockUserEntity.user3,
            MockUserEntity.user4,
            MockUserEntity.user5]
        
        mockGithubAPI.userListPublisher = .success(inputData)
        
        githubUserListModel.getGithubUserList(since: 0, numberOfPage: UInt(outputData.count))
            .sink { completion in
                if case .failure(_) = completion {
                    XCTFail("Something went wrong")
                }
            } receiveValue: { user in
                XCTAssertEqual(user, outputData, "Wrong data")
            }
            .store(in: &subscribers)
    }
    
    func testLoadGitHubUsersFailure() throws {
        mockGithubAPI.userListPublisher = .failure(HTTPError.statusCode)
        
        githubUserListModel.getGithubUserList(since: 0, numberOfPage: 10)
            .sink { completion in
                if case .failure(_) = completion {
                    
                } else {
                    XCTFail("Should be failure")
                }
            } receiveValue: { user in
                // nothing
            }
            .store(in: &subscribers)
    }
    
    func testLoadGitHubUsersWrongData() throws {
        let inputData = [
            MockGithubUser.user1,
            MockGithubUser.user2,
            MockGithubUser.user3,
            MockGithubUser.user4,
            MockGithubUser.user5]
        
        let outputData = [
            MockUserEntity.user1,
            MockUserEntity.user2,
            MockUserEntity.user3,
            MockUserEntity.user4]
        
        mockGithubAPI.userListPublisher = .success(inputData)
        
        githubUserListModel.getGithubUserList(since: 0, numberOfPage: UInt(outputData.count))
            .sink { completion in
                if case .failure(_) = completion {
                    XCTFail("Something went wrong")
                }
            } receiveValue: { user in
                XCTAssertNotEqual(user, outputData, "Wrong data")
            }
            .store(in: &subscribers)
        
    }
}
