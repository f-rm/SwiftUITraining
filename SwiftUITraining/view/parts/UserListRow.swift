//
//  UserListRow.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import SwiftUI

struct UserListRow: View {
    var user: User
    var body: some View {
        HStack {
            ImageView(urlStr: user.avatar ?? "",
                      placeholder: Image("noimage"))
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .shadow(radius: 5)
            Spacer()
            VStack(alignment: .leading) {
                if let firstName = user.firstName,
                   let lastName = user.lastName {
                    Text(firstName + " " + lastName).font(.title)
                }
            }.padding()
        }
    }
}

struct UserListRow_Previews: PreviewProvider {
    static var previews: some View {
        let user = User(id: 1, email: "aaa@email.com", firstName: "name", lastName: "name", avatar: "")
        UserListRow(user: user)
    }
}
