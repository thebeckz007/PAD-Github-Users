//
//  GithubUserDetailScreenViewModel.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//
//

import Foundation
import Combine

// MARK: Protocol GithubUserDetailScreenViewModelprotocol
/// protocol GithubUserDetailScreenViewModelprotocol
protocol GithubUserDetailScreenViewModelprotocol: BaseViewModelProtocol {
    func getGithubUserDetail()
    func gotoBack()
}

// MARK: class GithubUserDetailScreenViewModel
/// class GithubUserDetailScreenViewModel
class GithubUserDetailScreenViewModel: ObservableObject, GithubUserDetailScreenViewModelprotocol {
    private let githubUserDetailModel: GithubUserDetailScreenModelprotocol
    var subscriptions = Set<AnyCancellable>()
    
    @Published var user: UserEntity
    @Published var errMessage: String = ""
    @Published var isShownError: Bool = false
    @Published var isLoading: Bool = false
    
    init(githubUserDetailModel: GithubUserDetailScreenModelprotocol, user: UserEntity) {
        self.githubUserDetailModel = githubUserDetailModel
        self.user = user
    }
    
    func getGithubUserDetail() {
        isLoading = true
        isShownError = false
        
        githubUserDetailModel.getGithubUserDetail(userID: user.login)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self else { return }
                
                if case .failure(_) = completion {
                    // error
                    self.errMessage = "Something went wrong!!!"
                    self.isShownError = true
                }
                
                isLoading = false
            } receiveValue: { [weak self] user in
                guard let self else { return }
                
                self.user = user
            }
            .store(in: &subscriptions)
    }
    
    func gotoBack() {
        
    }
}
