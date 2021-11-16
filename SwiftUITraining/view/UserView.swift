//
//  UserView.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import SwiftUI

struct UserView: View {
    var userViewModel: UserViewModel
    var body: some View {
        VStack(alignment: .center) {
            Spacer().frame(height: 40)
            ImageView(urlStr: userViewModel.user.avatar ?? "",
                      placeholder: Image("noimage"))
                .frame(width: 200, height: 200)
                .clipShape(Circle())
                .shadow(radius: 20)
            if let firstName = userViewModel.user.firstName,
               let lastName = userViewModel.user.lastName {
                Text(firstName + " " + lastName).font(.largeTitle)
            }
            Spacer()
        }.frame(alignment: .top)
        .navigationTitle("user detail")
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView(userViewModel: UserViewModel(user: User(id: 1, email: "aaa@email.com", firstName: "name", lastName: "name", avatar: "")))
    }
}
