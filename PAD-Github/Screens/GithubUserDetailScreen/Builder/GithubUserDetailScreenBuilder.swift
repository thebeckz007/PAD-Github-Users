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
/// We use GithubUserListScreenBuilder to setup GithubUserDetailScreen
class GithubUserDetailScreenBuilder: GithubUserDetailScreenBuilderprotocol {
    /// setup function
    /// - Returns: instance of GithubUserDetailScreenView
    class func setup(user: UserEntity) -> GithubUserDetailScreenView {
         let model = GithubUserDetailScreenModel(githubAPI: World.shared.githubAPI)
         let viewmodel = GithubUserDetailScreenViewModel(githubUserDetailModel: model, user: user)
         let view = GithubUserDetailScreenView(viewmodel: viewmodel)
         
         return view
     }
}
