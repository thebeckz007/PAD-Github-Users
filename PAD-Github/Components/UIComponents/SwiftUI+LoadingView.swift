//
//  File.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//

import SwiftUI

struct LoadingView : View {
    var body: some View {
        return ProgressView()
            .scaleEffect(2)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.gray.opacity(0.3))
    }
}
