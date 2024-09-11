//
//  GithubUserListScreenViewModel.swift
//  PAD-GithubTests
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import XCTest
import Combine

// MARK: class GithubUserListScreenViewModelTest
/// class GithubUserListScreenViewModelTest
/// There are test cases of GithubUserListScreenViewModel
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
    
    /// testLoadUsersSuccess
    /// Test case: Fetching user list was success
    /// 1. Simulate response of get  user list function was success with inputData (user1,user2,user3,user4,user5).
    /// 2. Perform fetching user list API.
    /// 3. Check response of this request above. It should be equal outputData (user1,user2,user3,user4,user5) as expected.
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
    
    /// testLoadUsersFailure
    /// Test case: Fetching user list was failure
    /// 1. Simulate response of get user list function was failure.
    /// 2. Perform fetching user list API.
    /// 3. Check response of this request above. It should be get an error.
    /// 3.1 errMessage should be not empty
    /// 3.2 isShowError should true.
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
    
    /// testLoadUsersWrongData
    /// Test case: Fetching user list was reviced unexpected data
    /// 1. Simulate response of get user list function was success with inputData (user1,user2,user3,user4,user5).
    /// 2. Perform fetching github user list API.
    /// 3. Check response of this request above. It should be not equal outputData (user1,user2,user3,user4) as expected.
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
    
    /// testEnableLoadMore
    /// Test case: enableLoadmore should be true
    /// 1. Simulate response of get  user list function was success with inputData that contains 20 records (users) to exceed the number of page limit (20).
    /// 2. Perform fetching user list API.
    /// 3. Check response of this request above. enableLoadMore flag should be true as expected.
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
            MockUserEntity.user10,
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
    
    /// testEnableLoadMore
    /// Test case: enableLoadmore should be true
    /// 1. Simulate response of get  user list function was success with inputData that contains 10 records (users) not to exceed the number of page limit (20).
    /// 2. Perform fetching user list API.
    /// 3. Check response of this request above. enableLoadMore flag should be false as expected.
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
