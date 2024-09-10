//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 10/09/2024.
//

import Foundation

class World {
    
    // Static shared instance
    static let shared = World()
    
    //
    var githubAPI: GithubAPI

    // Private initializer to prevent the creation of another instance
    private init() {
        // Initialization code here
        githubAPI = GithubAPI(baseURL: URL(string: "https://api.github.com")!, networkSession: URLSession.shared)
    }

    // Example method in the world class
    func performAction() {
        print("Performing an action")
    }
}
