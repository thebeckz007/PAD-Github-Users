//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import Foundation

// MARK: class World
/// class World
/// to store all global instance of services/modules
class World {
    
    /// Static shared instance
    static let shared = World()
    
    /// githubAPI instance
    var githubAPI: GithubAPI

    /// Private initializer to prevent the creation of another instance
    private init() {
        // Initialization code here
        githubAPI = GithubAPI(baseURL: URL(string: "https://api.github.com")!, networkSession: URLSession.shared)
    }
}
