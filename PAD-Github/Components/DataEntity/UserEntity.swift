//
//  userEntity.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Foundation

struct UserEntity: Equatable {
    let Id: Int
    let login: String
    let avatar_url: String
    let html_url: String
    
    let name: String?
    let blog: String?
    let email: String?
    let location: String?
    let company: [String]?
    let follower: UInt?
    let following: UInt?
    
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
