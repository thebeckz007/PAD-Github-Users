//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Foundation

// MARK: struct GithubUser
// struct GithubUser
struct GithubUser: Decodable {
    /// Id of GithubUser as Int
    let Id: Int
    
    /// Login name of GithubUser as String
    let login: String
    
    /// Avater url of GithubUser as String
    let avatar_url: String
    
    /// Html url of GithubUser as String
    let html_url: String
    
    /// Full name of GithubUser as String
    let name: String?
    
    /// Blog page of GithubUser as String
    let blog: String?
    
    /// Email of GithubUser as String
    let email: String?
    
    /// Location of GithubUser as String
    let location: String?
    
    /// Company list of GithubUser as String array
    let company: [String]?
    
    /// Number of follower as UInt
    let follower: UInt?
    
    /// Number of following as UInt
    let following: UInt?
    
    /// Initialize function
    init(Id: Int, login: String, avatar_url: String, html_url: String, name: String?, blog: String?, email: String?, location: String?, company: [String]?, follower: UInt?, following: UInt?) {
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
    
    /// Initialize function from decoder
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.Id = try container.decodeIfPresent(Int.self, forKey: .Id) ?? 0
        self.login = try container.decode(String.self, forKey: .login)
        self.avatar_url = try container.decode(String.self, forKey: .avatar_url)
        self.html_url = try container.decode(String.self, forKey: .html_url)
        
        self.location = try? container.decodeIfPresent(String.self, forKey: .location)
        self.follower = try? container.decodeIfPresent(UInt.self, forKey: .follower)
        self.following = try? container.decodeIfPresent(UInt.self, forKey: .following)
        self.name = try? container.decodeIfPresent(String.self, forKey: .name)
        self.blog = try? container.decode(String.self, forKey: .blog)
        self.company = try? container.decodeIfPresent([String].self, forKey: .company)
        self.email = try? container.decodeIfPresent(String.self, forKey: .email)
    }

    // MARK: Internal
    /// enum Codingkeys
    enum CodingKeys: String, CodingKey {
        case Id = "id"
        case login = "login"
        case avatar_url = "avatar_url"
        case html_url = "html_url"
        case location = "location"
        case follower = "followers"
        case following = "following"
        case name = "name"
        case blog = "blog"
        case company = "company"
        case email = "email"
    }
}
