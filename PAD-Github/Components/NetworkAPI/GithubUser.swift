//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import Foundation

struct GithubUser: Decodable {
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
