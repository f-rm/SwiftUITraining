//
//  UserViewModel.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import UIKit

class UserViewModel: ObservableObject {

    @Published var user: User
    
    init(user: User) {
        self.user = user
    }
}
