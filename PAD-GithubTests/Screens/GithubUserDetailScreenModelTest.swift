//
//  GithubUserDetailScreenTest.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import XCTest
import Combine

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
    
    func testLoadGitHubUsersFailure() throws {
        let inputData = MockGithubUser.user1
        let outputData = MockUserEntity.user1
        
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
