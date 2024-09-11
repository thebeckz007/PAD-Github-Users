//
//  GithubUserListScreenViewModel.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//
//

import Foundation
import Combine

// MARK: Protocol GithubUserListScreenViewModelprotocol
/// protocol GithubUserListScreenViewModelprotocol
protocol GithubUserListScreenViewModelprotocol: BaseViewModelProtocol {
    /// refreshGithubUserList function
    /// Refresh user list
    func refreshGithubUserList()
    
    /// loadmoreGithubUserList function
    /// Load more users
    func loadmoreGithubUserList()
    
    /// gotoGithubUserDetail function
    /// Navigate to User Detail screen
    /// - Parameter user: user as UserEntity
    /// - Returns: a view as GithubUserDetailScreenView
    func gotoGithubUserDetail(_ user: UserEntity) -> GithubUserDetailScreenView
}

// MARK: class GithubUserListScreenViewModel
/// class GithubUserListScreenViewModel
class GithubUserListScreenViewModel: ObservableObject, GithubUserListScreenViewModelprotocol {
    /// githubUserListModel as GithubUserListScreenModelprotocol
    private let githubUserListModel: GithubUserListScreenModelprotocol
    
    @Published var userList = [UserEntity]()
    @Published var errMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var enableLoadMore: Bool = false
    @Published var isShownError: Bool = false
    
    /// numberOfPage as Uint constant
    private let numberOfPage: UInt = 20
    
    /// sinceUserID as Int. It likes Id of the last user of user list
    private var sinceUserID: Int = 0
    
    /// subscriptions to store  publisher
    private var subscriptions = Set<AnyCancellable>()
    
    init(githubUserListModel: GithubUserListScreenModelprotocol) {
        self.githubUserListModel = githubUserListModel
    }
    
    func refreshGithubUserList() {
        // Reset conditional variables
        sinceUserID = 0
        
        // Show loading view
        isLoading = true
        
        // Perform fetching user list
        getGithubUserList()
    }
    
    func loadmoreGithubUserList() {
        // Perform fetching user list
        getGithubUserList()
    }
    
    private func getGithubUserList() {
        // Reset conditional variables
        // Force hide error popup if appeared before
        errMessage = ""
        isShownError = false
        
        githubUserListModel.getGithubUserList(since: UInt(sinceUserID), numberOfPage: numberOfPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                // Check and throw error as popup when has an error
                if case .failure(_) = completion {
                    self.errMessage = "Something went wrong!!!"
                    self.isShownError = true
                }
                
                // stop loading
                self.isLoading = false
            } receiveValue: { [weak self] users in
                guard let self else { return }
                
                // check to replace users data or append them
                if self.sinceUserID == 0 {
                    // There's refreshing state, so we will replace the data
                    self.userList = users
                } else {
                    // There's loading more state, so we will append the data
                    self.userList.append(contentsOf: users)
                }
                
                // set the Id of last user of the user list currently
                if let lastUser = self.userList.last {
                    self.sinceUserID = lastUser.Id
                } else {
                    // something went wrong, we will set 0 as default value
                    self.sinceUserID = 0
                }
                
                // Check and take on the enableLoadMore flag
                if self.userList.count > 0, self.userList.count % Int(self.numberOfPage) == 0 {
                    // If the number of users in the data is divisible by number of page (20), it means there may still be more data to load. Therefore, we will set true to enableLoadMore flag.
                    self.enableLoadMore = true
                } else {
                    // Otherwise, enableLoadMore flag should be false as no more data to load.
                    self.enableLoadMore = false
                }
            }
            .store(in: &subscriptions)
    }
    
    func gotoGithubUserDetail(_ user: UserEntity) -> GithubUserDetailScreenView {
        return GithubUserDetailScreenBuilder.setup(user: user)
    }
}
