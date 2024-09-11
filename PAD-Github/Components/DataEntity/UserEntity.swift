//
//  userEntity.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Foundation

// MARK: struct UserEntity
/// struct UserEntity
/// We use the UserEntity model for the UI layer. It helps us avoid depending on the GithubUser from the Network module.
struct UserEntity: Equatable {
    /// Id of User as Int
    let Id: Int
    
    /// Login name of User as String
    let login: String
    
    /// Avater url of User as String
    let avatar_url: String
    
    /// Html url of User as String
    let html_url: String
    
    /// Full name of User as String
    let name: String?
    
    /// Blog page of User as String
    let blog: String?
    
    /// Email of User as String
    let email: String?
    
    /// Location of User as String
    let location: String?
    
    /// Company list of User as String array
    let company: [String]?
    
    /// Number of follower as UInt
    let follower: UInt?
    
    /// Number of following as UInt
    let following: UInt?
    
    /// Initialize function
    init(Id: Int, login: String, avatar_url: String, html_url: String, name: String?, blog: String?, email: String?, location: String?, company: [String]?, follower: UInt?, following: UInt?)
    {
        self.Id = Id
        self.login = login
        self.avatar_url = avatar_url
        self.html_url = html_url
        self.name = name
        self.blog = blog
        self.email = email
        self.location = location
        self.company = company
        self.follower = follower
        self.following = following
    }
    
    /// Initialize UserEntity from GithubUser
    /// - Parameter githubUserAPI: user as GithubUser
    init(githubUserAPI: GithubUser) {
        self.init(
            Id: githubUserAPI.Id,
            login: githubUserAPI.login,
            avatar_url: githubUserAPI.avatar_url,
            html_url: githubUserAPI.html_url,
            name: githubUserAPI.name,
            blog: githubUserAPI.blog,
            email: githubUserAPI.email,
            location: githubUserAPI.location,
            company: githubUserAPI.company,
            follower: githubUserAPI.follower,
            following: githubUserAPI.following)
    }
}
