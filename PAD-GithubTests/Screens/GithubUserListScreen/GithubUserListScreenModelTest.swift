//
//  GithubUserListScreenModel.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import XCTest
import Combine

// MARK: class GithubUserListScreenModelTest
/// class GithubUserListScreenModelTest
/// There are test cases of GithubUserListScreenModel
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

    /// testLoadGitHubUsersSuccess
    /// Test case: Fetching github user list was success
    /// 1. Simulate response of get github user list function was success with inputData (user1,user2,user3,user4,user5).
    /// 2. Perform fetching github user list API.
    /// 3. Check response of this request above. It should be equal outputData (user1,user2,user3,user4,user5) as expected.
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
    
    /// testLoadGitHubUsersFailure
    /// Test case: Fetching github user list was failure
    /// 1. Simulate response of get github user list function was failure.
    /// 2. Perform fetching github user list API.
    /// 3. Check response of this request above. It should be get an error.
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
    
    /// testLoadGitHubUsersWrongData
    /// Test case: Fetching github user list was reviced unexpected data
    /// 1. Simulate response of get github user list function was success with inputData (user1,user2,user3,user4,user5).
    /// 2. Perform fetching github user list API.
    /// 3. Check response of this request above. It should be not equal outputData (user1,user2,user3,user4) as expected.
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
