//
//  UserListView.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import SwiftUI

struct UserListView: View {
    
    @ObservedObject var userListViewModel: UserListViewModel
    @State private var isShowLogin = true
    
    var body: some View {
        NavigationView {
            List(self.userListViewModel.userList, id: \.id) { user in
                let userViewModel = UserViewModel(user: user)
                NavigationLink(destination: UserView(userViewModel: userViewModel)) {
                    UserListRow(user: user)
                }
            }
            .navigationTitle("user list")
            .navigationBarItems(
                leading:
                    Button("logout", action: {
                        isShowLogin.toggle()
                    })
            )
            .fullScreenCover(isPresented: $isShowLogin, content: {LoginView()})
        }.onAppear(perform: loadData)
    }
    
    func loadData() {
        guard let url = URL(string: "https://my-json-server.typicode.com/f-rm/SwiftUITraining/users") else {
            return
        }
        
        let reqest = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: reqest) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(UserResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.userListViewModel.userList = response.data
                    }
                }
            }
        }.resume()
    }
}

struct UserListView_Previews: PreviewProvider {
    static var previews: some View {
        let userListViewModel = UserListViewModel(userList: [])
        UserListView(userListViewModel: userListViewModel)
    }
}
