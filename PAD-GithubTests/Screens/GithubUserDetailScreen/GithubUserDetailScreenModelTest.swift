//
//  GithubUserDetailScreenTest.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import XCTest
import Combine

// MARK: class GithubUserListScreenVGithubUserDetailScreenModelTestiewModelTest
/// class GithubUserDetailScreenModelTest
/// There are test cases of GithubUserDetailScreenModel
final class GithubUserDetailScreenModelTest: XCTestCase {
    public var githubUserDetailModel: GithubUserDetailScreenModel!
    public var mockGithubAPI: MockGithubAPI!
    public var subscribers = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockGithubAPI = MockGithubAPI()
        githubUserDetailModel = GithubUserDetailScreenModel(githubAPI: mockGithubAPI)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        subscribers.removeAll()
    }

    /// testLoadGitHubUsersSuccess
    /// Test case: Fetching github user detail was success
    /// 1. Simulate response of get github user detail function was success with inputData(user1).
    /// 2. Perform fetching github user detail API.
    /// 3. Check response of this request above. It should be equal outputData(user1) as expected.
    func testLoadGitHubUsersSuccess() throws {
        let inputData = MockGithubUser.user1
        let outputData = MockUserEntity.user1
        
        mockGithubAPI.userDetailPublisher = .success(inputData)
        
        githubUserDetailModel.getGithubUserDetail(userID: "\(inputData.Id)")
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
    /// Test case: Fetching github user detail was failure
    /// 1. Simulate response of get github user detail function was failure.
    /// 2. Perform fetching github user detail API.
    /// 3. Check response of this request above. It should be get an error.
    func testLoadGitHubUsersFailure() throws {
        let inputData = MockGithubUser.user1
        
        mockGithubAPI.userDetailPublisher = .failure(HTTPError.statusCode)
        
        githubUserDetailModel.getGithubUserDetail(userID: "\(inputData.Id)")
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
    /// Test case: Fetching github user detail was reviced unexpected data
    /// 1. Simulate response of get github user detail function was success with inputData (user1).
    /// 2. Perform fetching github user detail API.
    /// 3. Check response of this request above. It should be not equal outputData (user2) as expected.
    func testLoadGitHubUsersWrongData() throws {
        let inputData = MockGithubUser.user1
        let outputData = MockUserEntity.user2
        
        mockGithubAPI.userDetailPublisher = .success(inputData)
        
        githubUserDetailModel.getGithubUserDetail(userID: "\(inputData.Id)")
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
