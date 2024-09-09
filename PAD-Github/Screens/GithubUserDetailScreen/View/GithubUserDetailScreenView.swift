//
//  GithubUserDetailScreenView.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//
//

import SwiftUI
import Combine

// MARK: struct constIDViewGithubUserDetailScreenView
/// List IDview of all views as a const variable
struct constIDViewGithubUserDetailScreenView {
    // TODO: Define IDView of all view compenents in here
    // Example with naming convention for this
    // static let _idView_<ViewComponent> = "_idView_<ViewComponent>"
}

// MARK: protocol GithubUserDetailScreenViewprotocol
/// protocol GithubUserDetailScreenViewprotocol
protocol GithubUserDetailScreenViewprotocol: BaseViewProtocol {
    
}

// MARK: Struct GithubUserDetailScreenView
/// Contruct main view
struct GithubUserDetailScreenView : View, GithubUserDetailScreenViewprotocol {
    @ObservedObject private var viewmodel: GithubUserDetailScreenViewModel
    
    init(viewmodel: GithubUserDetailScreenViewModel) {
        self.viewmodel = viewmodel
    }
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(alignment: .leading) {
                userdetailCell(user: viewmodel.user)
                    .padding(20.0)
                
                HStack(alignment: .top) {
                    Spacer()
                    VStack(alignment: .center) {
                        ZStack(alignment: .center) {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                            
                            Image(.followers)
                                .resizable()
                                .scaledToFit()
                                .padding(10.0)
                        }
                        .frame(width: 50, height: 50)
                        
                        Text("\(viewmodel.user.follower ?? 0)")
                        Text("Follower")
                    }
                    Spacer()
                    VStack(alignment: .center) {
                        ZStack(alignment: .center) {
                            Circle()
                                .fill(Color.gray.opacity(0.2))
                            
                            Image(.medal)
                                .resizable()
                                .scaledToFit()
                                .padding(10.0)
                        }
                        .frame(width: 50, height: 50)
                        
                        Text("\(viewmodel.user.following ?? 0)")
                        Text("Following")
                    }
                    Spacer()
                }
                .background(.clear)
                
                VStack(alignment: .leading) {
                    Text("Blog")
                        .font(.system(size: 22, weight: .bold))
                    
                    Text(viewmodel.user.blog ?? "---")
                        .font(.system(size: 14))
                }
                .background(.clear)
                .padding( .leading, 20.0)
                .padding( .top, 10.0)
                
                Spacer()
            }
            
            if self.viewmodel.isLoading {
                LoadingView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray.opacity(0.1))
        .onAppear {
            viewmodel.getGithubUserDetail()
        }
        .alert("Network failure", isPresented: $viewmodel.isShownError, actions: {
            Button("Cancel", role: .cancel) {
                dismiss()
            }
            
            Button("Retry", role: .none) {
                viewmodel.getGithubUserDetail()
            }
        }, message: {
            Text(viewmodel.errMessage)
        })
        .navigationTitle("User Details")
    }
    
    @ViewBuilder
    private func userdetailCell(user: UserEntity) -> some View {
        HStack(alignment: .top) {
            AsyncImage(url: URL(string: user.avatar_url)) { image in
                image.resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            } placeholder: {
                ZStack{
                    Image(.imagePhoto)
                        .resizable()
                        .clipShape(Circle())
                    
                    ProgressView()
                }
                .frame(width: 100, height: 100)
            }
            .padding(20.0)

            VStack(alignment: .leading) {
                Text(user.name ?? user.login).font(.system(size: 22, weight: .bold))
                Divider()
                    .padding(.trailing, 20)
                HStack(alignment: .top) {
                    Image(systemName: "mappin.and.ellipse.circle")
                    Text(user.location ?? "---").font(.system(size: 14))
                }
                .padding(.top, 10.0)
            }
            .padding(.top, 20)
        }
        .background(.white)
        .clipShape(.buttonBorder)
    }
}

#Preview {
    let user = UserEntity.init(Id: 7, login: "Thebeckz007", avatar_url: "https://avatars.githubusercontent.com/u/8088027?v=4", html_url: "https://github.com/thebeckz007", name: "Duy Phan", blog: "https://duyphanspace.wordpress.com/", email: "Thebeckz007@gmail.com", location: "Ho Chi Minh", company: ["Nami", "Fossil", "Misfit"], follower: 107, following: 17)
    
    let mockModel = MockGithubUserDetailScreenModel(userDetailPublisher: .success(user))
    
    return GithubUserDetailScreenView(viewmodel: GithubUserDetailScreenViewModel(githubUserDetailModel: mockModel, user: user))
    
    
}
