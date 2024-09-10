//
//  GithubUserListScreenView.swift
//  PAD-Github
//
//  Created by Phan Anh Duy on 09/09/2024.
//
//

import SwiftUI
import Combine

// MARK: struct constIDViewGithubUserListScreenView
/// List IDview of all views as a const variable
struct constIDViewGithubUserListScreenView {
    // TODO: Define IDView of all view compenents in here
    // Example with naming convention for this
    // static let _idView_<ViewComponent> = "_idView_<ViewComponent>"
}

// MARK: protocol GithubUserListScreenViewprotocol
/// protocol GithubUserListScreenViewprotocol
protocol GithubUserListScreenViewprotocol: BaseViewProtocol {
    
}

// MARK: Struct GithubUserListScreenView
/// Contruct main view
struct GithubUserListScreenView : View, GithubUserListScreenViewprotocol {
    @ObservedObject private var viewmodel: GithubUserListScreenViewModel
    @Environment(\.dismiss) var dismiss
    
    init(viewmodel: GithubUserListScreenViewModel) {
        self.viewmodel = viewmodel
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                List {
                    ForEach(viewmodel.userList, id:\.Id) { user in
                        userListCell(user: user)
                    }
                    
                    if viewmodel.enableLoadMore {
                        HStack(alignment: .center) {
                            ProgressView()
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: 1)) {
                                        self.viewmodel.loadmoreGithubUserList()
                                    }
                                }
                        }
                    }
                }
                .listRowSpacing(10.0)
                .navigationTitle("Github Users")
                .refreshable {
                    viewmodel.refreshGithubUserList()
                }
            }
            
            if self.viewmodel.isLoading {
                LoadingView()
            }
        }
        .onAppear {
            viewmodel.refreshGithubUserList()
        }
        .alert("Network failure", isPresented: $viewmodel.isShownError, actions: {
            Button("Ok", role: .none) {
                
            }
        }, message: {
            Text(viewmodel.errMessage)
        })
    }
    
    @ViewBuilder
    private func userListCell(user: UserEntity) -> some View {
        NavigationLink(destination: viewmodel.gotoGithubUserDetail(user)) {
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
                    Text(user.login).font(.system(size: 22, weight: .bold))
                    Divider()
                        .padding(.trailing, 20)
                    Text(.init("[\(user.html_url)](\(user.html_url))")).font(.system(size: 14))
                        .padding(.top, 10.0)
                }
                .padding(.top, 20)
            }
            .background(.white)
            .clipShape(.buttonBorder)
        }
    }
}

#Preview {
    let mockData = [MockUserEntity.user1,
                    MockUserEntity.user2,
                    MockUserEntity.user3,
                    MockUserEntity.user4,
                    MockUserEntity.user5,
                    MockUserEntity.user6,
                    MockUserEntity.user7,
                    MockUserEntity.user8,
                    MockUserEntity.user9,
                    MockUserEntity.user10]
    
    let mockModel = MockGithubUserListScreenModel()
    mockModel.userListPublisher = .success(mockData)
    
    return GithubUserListScreenView(viewmodel: GithubUserListScreenViewModel(githubUserListModel: mockModel))
}
