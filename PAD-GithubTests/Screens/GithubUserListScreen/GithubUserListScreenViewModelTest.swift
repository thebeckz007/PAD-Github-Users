//
//  GithubUserListScreenViewModel.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import XCTest
import Combine

final class GithubUserListScreenViewModelTest: XCTestCase {
    public var viewModel: GithubUserListScreenViewModel!
    public var mockModel: MockGithubUserListScreenModel!
    public var subscribers = Set<AnyCancellable>()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        mockModel = MockGithubUserListScreenModel()
        viewModel = GithubUserListScreenViewModel(githubUserListModel: mockModel)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        subscribers.removeAll()
    }
    
    func testLoadUsersSuccess() throws {
        let loadUsersExpectation = XCTestExpectation()
        
        let expectedData = [
            MockUserEntity.user1,
            MockUserEntity.user2,
            MockUserEntity.user3,
            MockUserEntity.user4,
            MockUserEntity.user5]
        
        mockModel.userListPublisher = .success(expectedData)
        viewModel.refreshGithubUserList()
        
        viewModel.$userList
            .dropFirst()
            .sink { users in
                XCTAssertEqual(users, expectedData, "Wrong data")
                loadUsersExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [loadUsersExpectation], timeout: 1.0)
    }
    
    func testLoadUsersFailure() throws {
        let errorMsgExpectation = XCTestExpectation()
        let isShowErrorExpectation = XCTestExpectation()
        
        mockModel.userListPublisher = .failure(HTTPError.statusCode)
        viewModel.refreshGithubUserList()
        
        viewModel.$errMessage
            .dropFirst()
            .sink { err in
                XCTAssertNotEqual(err, "", "Should be not empty")
                errorMsgExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        viewModel.$isShownError
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
        let loadUsersExpectation = XCTestExpectation()
        
        let inputData = [
            MockUserEntity.user1,
            MockUserEntity.user2,
            MockUserEntity.user3,
            MockUserEntity.user4,
            MockUserEntity.user5]
        
        let outputData = [
            MockUserEntity.user1,
            MockUserEntity.user2,
            MockUserEntity.user3,
            MockUserEntity.user4]
        
        mockModel.userListPublisher = .success(inputData)
        viewModel.refreshGithubUserList()
        
        viewModel.$userList
            .dropFirst()
            .sink { user in
                XCTAssertNotEqual(user, outputData, "Wrong data")
                loadUsersExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [loadUsersExpectation], timeout: 1.0)
    }
    
    func testEnableLoadMore() throws {
        let loadMoreExpectation = XCTestExpectation()
        
        let inputData = [
            MockUserEntity.user1,
            MockUserEntity.user2,
            MockUserEntity.user3,
            MockUserEntity.user4,
            MockUserEntity.user5,
            MockUserEntity.user6,
            MockUserEntity.user7,
            MockUserEntity.user8,
            MockUserEntity.user9,
            MockUserEntity.user10]
        
        mockModel.userListPublisher = .success(inputData)
        viewModel.refreshGithubUserList()
        
        viewModel.$enableLoadMore
            .dropFirst()
            .sink { isLoadMore in
                XCTAssertTrue(isLoadMore, "Should be enabled load more")
                loadMoreExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [loadMoreExpectation], timeout: 1.0)
    }
    
    func testNotEnableLoadMore() throws {
        let loadMoreExpectation = XCTestExpectation()
        
        let inputData = [
            MockUserEntity.user1,
            MockUserEntity.user2,
            MockUserEntity.user3,
            MockUserEntity.user4,
            MockUserEntity.user5,
            MockUserEntity.user6,
            MockUserEntity.user7,
            MockUserEntity.user8,
            MockUserEntity.user9]
        
        mockModel.userListPublisher = .success(inputData)
        viewModel.refreshGithubUserList()
        
        viewModel.$enableLoadMore
            .dropFirst()
            .sink { isLoadMore in
                XCTAssertFalse(isLoadMore, "Should be not enabled load more")
                loadMoreExpectation.fulfill()
            }
            .store(in: &subscribers)
        
        wait(for: [loadMoreExpectation], timeout: 1.0)
    }
}
