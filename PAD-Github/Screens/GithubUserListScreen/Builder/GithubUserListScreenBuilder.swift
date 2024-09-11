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
/// We use GithubUserListScreenBuilder to setup GithubUserListScreen
class GithubUserListScreenBuilder: GithubUserListScreenBuilderprotocol {
    /// setup function
    /// - Returns: instance of GithubUserListScreenView
     class func setup() -> GithubUserListScreenView {
         let model = GithubUserListScreenModel(githubAPI: World.shared.githubAPI)
         let viewmodel = GithubUserListScreenViewModel(githubUserListModel: model)
         let view = GithubUserListScreenView(viewmodel: viewmodel)
         
         return view
     }
}
