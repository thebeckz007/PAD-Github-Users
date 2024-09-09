//
//  GithubUserListScreenBuilder.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//
//

import Foundation

// MARK: Protocol GithubUserListScreenBuilderprotocol
/// protcol GithubUserListScreenBuilderprotocol
protocol GithubUserListScreenBuilderprotocol: BaseBuilderProtocol {
    
}

// MARK: class GithubUserListScreenBuilder
/// class GithubUserListScreenBuilder
class GithubUserListScreenBuilder: GithubUserListScreenBuilderprotocol {
     class func setup() -> GithubUserListScreenView {
         let model = GithubUserListScreenModel(githubAPI: GithubAPI(baseURL: URL(string: "https://api.github.com")!, networkSession: URLSession.shared))
         let viewmodel = GithubUserListScreenViewModel(githubUserListModel: model)
         let view = GithubUserListScreenView(viewmodel: viewmodel)
         
         return view
     }
}
