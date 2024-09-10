//
//  GithubUserDetailScreenViewModelTest.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import XCTest
import Combine

final class GithubUserDetailScreenViewModelTest: XCTestCase {
    public var githubUserDetailViewModel: GithubUserDetailScreenViewModel!
    public var mockModel: MockGithubUserDetailScreenModel!
    public var subscribers = Set<AnyCancellable>()
    public let inputData = MockUserEntity.user1
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockModel = MockGithubUserDetailScreenModel()
        githubUserDetailViewModel = GithubUserDetailScreenViewModel(githubUserDetailModel: mockModel, user: inputData)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        subscribers.removeAll()
    }

    func testLoadUsersSuccess() throws {
        let outputData = MockUserEntity.user1
        
        mockModel.userDetailPublisher = .success(outputData)
        
        githubUserDetailViewModel.$user
            .sink { user in
                XCTAssertEqual(user, outputData, "Wrong data")
            }
            .store(in: &subscribers)
    }
    
    func testLoadUsersFailure() throws {
        mockModel.userDetailPublisher = .failure(HTTPError.statusCode)
        
        githubUserDetailViewModel.$isShownError
            .sink { isShowError in
                XCTAssertTrue(true, "Should be an error")
            }
            .store(in: &subscribers)
    }
    
    func testLoadUsersWrongData() throws {
        let outputData = MockUserEntity.user2
        
        mockModel.userDetailPublisher = .success(outputData)
        
        githubUserDetailViewModel.$user
            .sink { user in
                XCTAssertNotEqual(user, outputData, "Wrong data")
            }
            .store(in: &subscribers)
    }
}
