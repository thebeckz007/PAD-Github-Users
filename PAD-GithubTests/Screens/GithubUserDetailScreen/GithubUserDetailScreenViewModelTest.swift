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
