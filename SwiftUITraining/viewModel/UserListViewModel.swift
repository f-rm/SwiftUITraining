//
//  UserListViewModel.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import UIKit

class UserListViewModel: ObservableObject {
    
    @Published var userList: [User]
    
    init(userList: [User]) {
        self.userList = userList
    }
}
