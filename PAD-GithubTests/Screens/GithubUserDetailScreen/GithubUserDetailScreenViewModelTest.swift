//
//  GithubUserDetailScreenViewModelTest.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import XCTest
import Combine

// MARK: class GithubUserDetailScreenViewModelTest
/// class GithubUserDetailScreenViewModelTest
/// There are test cases of GithubUserDetailScreenViewModel
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

    /// testLoadUsersSuccess
    /// Test case: Fetching user detail was success
    /// 1. Simulate response of get github user detail function was success with inputData(user1).
    /// 2. Perform fetching github user detail API.
    /// 3. Check response of this request above. It should be equal outputData(user1) as expected.
    func testLoadUsersSuccess() throws {
        let userExpectation = XCTestExpectation()
        let outputData = MockUserEntity.user1
        
        mockModel.userDetailPublisher = .success(inputData)
        githubUserDetailViewModel.getGithubUserDetail()
        
        githubUserDetailViewModel.$user
            .dropFirst()
            .sink { user in
                XCTAssertEqual(user, outputData, "Wrong data")
                userExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [userExpectation], timeout: 1.0)
    }
    
    /// testLoadUsersFailure
    /// Test case: Fetching user detail was failure
    /// 1. Simulate response of get github user detail function was failure.
    /// 2. Perform fetching github user detail API.
    /// 3. Check response of this request above. It should be get an error.
    /// 3.1 errMessage should be not empty
    /// 3.2 isShowError should true.
    func testLoadUsersFailure() throws {
        let errorMsgExpectation = XCTestExpectation()
        let isShowErrorExpectation = XCTestExpectation()
        
        mockModel.userDetailPublisher = .failure(HTTPError.statusCode)
        githubUserDetailViewModel.getGithubUserDetail()
        
        githubUserDetailViewModel.$errMessage
            .dropFirst()
            .sink { err in
                XCTAssertNotEqual(err, "", "Should be not empty")
                errorMsgExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        githubUserDetailViewModel.$isShownError
            .removeDuplicates()
            .dropFirst()
            .sink { isShowError in
                XCTAssertTrue(isShowError, "Should be an error")
                isShowErrorExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [errorMsgExpectation, isShowErrorExpectation], timeout: 1.0)
    }
    
    /// testLoadUsersWrongData
    /// Test case: Fetching user detail was reviced unexpected data
    /// 1. Simulate response of get github user detail function was success with inputData (user1).
    /// 2. Perform fetching github user detail API.
    /// 3. Check response of this request above. It should be not equal outputData (user2) as expected.
    func testLoadUsersWrongData() throws {
        let userExpectation = XCTestExpectation()
        let outputData = MockUserEntity.user2
        
        mockModel.userDetailPublisher = .success(inputData)
        githubUserDetailViewModel.getGithubUserDetail()
        
        githubUserDetailViewModel.$user
            .dropFirst()
            .sink { user in
                XCTAssertNotEqual(user, outputData, "Wrong data")
                userExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [userExpectation], timeout: 1.0)
    }
}
