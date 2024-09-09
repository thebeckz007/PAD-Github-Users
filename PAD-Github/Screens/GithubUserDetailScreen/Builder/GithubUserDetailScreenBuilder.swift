//
//  GithubUserDetailScreenBuilder.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//
//

import Foundation

// MARK: Protocol GithubUserDetailScreenBuilderprotocol
/// protcol GithubUserDetailScreenBuilderprotocol
protocol GithubUserDetailScreenBuilderprotocol: BaseBuilderProtocol {
    
}

// MARK: class GithubUserDetailScreenBuilder
/// class GithubUserDetailScreenBuilder
class GithubUserDetailScreenBuilder: GithubUserDetailScreenBuilderprotocol {
    class func setup(user: UserEntity) -> GithubUserDetailScreenView {
         let model = GithubUserDetailScreenModel(githubAPI: GithubAPI(baseURL: URL(string: "https://api.github.com")!, networkSession: URLSession.shared))
         let viewmodel = GithubUserDetailScreenViewModel(githubUserDetailModel: model, user: user)
         let view = GithubUserDetailScreenView(viewmodel: viewmodel)
         
         return view
     }
}
