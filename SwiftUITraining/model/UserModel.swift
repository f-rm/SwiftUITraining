//
//  UserModel.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import SwiftUI

class UserResponse: Codable {
    var data: [User]
}

struct User: Codable {
    var id: Int
    var email: String?
    var firstName: String?
    var lastName: String?
    var avatar: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

extension User {
    var userImage: Image {
        guard let avatar = avatar,
              let url = URL(string: avatar) else {
            return Image("noimage")
        }
        return Image(uiImage: ImageStore(from: url).image)
    }
}
