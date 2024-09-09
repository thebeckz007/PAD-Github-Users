//
//  PAD_GithubApp.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import SwiftUI

@main
struct PAD_GithubApp: App {
    var body: some Scene {
        WindowGroup {
            GithubUserListScreenBuilder.setup()
        }
    }
}
