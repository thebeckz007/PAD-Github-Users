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
    func refreshGithubUserList()
    func loadmoreGithubUserList()
    func gotoGithubUserDetail(_ user: UserEntity) -> GithubUserDetailScreenView
}

// MARK: class GithubUserListScreenViewModel
/// class GithubUserListScreenViewModel
class GithubUserListScreenViewModel: ObservableObject, GithubUserListScreenViewModelprotocol {
    private let githubUserListModel: GithubUserListScreenModelprotocol
    
    @Published var userList = [UserEntity]()
    @Published var errMessage: String = ""
    @Published var isLoading: Bool = false
    @Published var enableLoadMore: Bool = false
    @Published var isShownError: Bool = false
    
    private let numberOfPage: UInt = 20
    private var sinceUserID: Int = 0
    private var subscriptions = Set<AnyCancellable>()
    
    init(githubUserListModel: GithubUserListScreenModelprotocol) {
        self.githubUserListModel = githubUserListModel
    }
    
    func refreshGithubUserList() {
        sinceUserID = 0
        
        isLoading = true
        errMessage = ""
        
        getGithubUserList()
    }
    
    func loadmoreGithubUserList() {
        getGithubUserList()
    }
    
    private func getGithubUserList() {
        isShownError = false
        
        githubUserListModel.getGithubUserList(since: UInt(sinceUserID), numberOfPage: numberOfPage)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(_) = completion {
                    // error
                    self.errMessage = "Something went wrong!!!"
                    self.isShownError = true
                }
                
                self.isLoading = false
            } receiveValue: { [weak self] users in
                guard let self else { return }
                
                //
                if self.sinceUserID == 0 {
                    self.userList = users
                } else {
                    self.userList.append(contentsOf: users)
                }
                
                //
                if let lastUser = self.userList.last {
                    self.sinceUserID = lastUser.Id
                } else {
                    self.sinceUserID = 0
                }
                
                if self.userList.count > 0, self.userList.count % Int(self.numberOfPage) == 0 {
                    self.enableLoadMore = true
                } else {
                    self.enableLoadMore = false
                }
            }
            .store(in: &subscriptions)
    }
    
    func gotoGithubUserDetail(_ user: UserEntity) -> GithubUserDetailScreenView {
        return GithubUserDetailScreenBuilder.setup(user: user)
    }
}
