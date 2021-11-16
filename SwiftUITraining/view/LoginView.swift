//
//  LoginView.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/30.
//

import SwiftUI

struct LoginView: View {
    @State var screen: CGSize?
    @State private var isShowUserRegist = false
    @ObservedObject var viewModel: LoginViewModel = .init()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView{
            VStack(alignment: .center) {
                Spacer().frame(height: 100)
                Group {
                    if let screen = screen {
                        EmailField(screen: screen, viewModel: viewModel)
                        PasswordField(screen: screen, viewModel: viewModel)
                    }
                }
                Spacer().frame(height: 60)
                Button(action: {
                    print("login button pressed!")
                    login()
                } ) {
                    Text("login")
                        .foregroundColor(Color.white)
                        .frame(width: 300, height: 20, alignment: .center)
                        .padding()
                        .background(self.viewModel.isValidInput ? Color.blue : Color.black.opacity(0.3))
                        .cornerRadius(100)
                }.frame(width: 300, height: 20, alignment: .center)
                .disabled(!self.viewModel.isValidInput)
                Spacer()
            }.navigationTitle("login").onAppear(){
                screen = UIScreen.main.bounds.size
            }.navigationBarItems(
                trailing:
                    Button(action: {
                        print("add button")
                        isShowUserRegist.toggle()
                    }) {
                        Text("regist")
                    }.sheet(isPresented: $isShowUserRegist) {
                        UserRegistView()
                    }
            )
        }
    }
    
    struct EmailField: View {
        @State var screen: CGSize?
        @ObservedObject var viewModel: LoginViewModel
        
        var body:some View {
            HStack {
                Image(systemName: "envelope.fill").frame(width: 20, height: 10, alignment: .leading)
                TextField("email", text: $viewModel.email)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: viewModel.email) { changed in
                        viewModel.hasChangedEmail = true
                    }.foregroundColor(.gray)
            }.underlineTextField().padding(.horizontal, 20)
            if let screen = screen {
                if viewModel.hasChangedEmail {
                    if !viewModel.isEmptyEmail.isEmpty {
                        Text(viewModel.isEmptyEmail)
                            .frame(width: screen.width - 40, height: 10, alignment: .leading)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    } else {
                        if !viewModel.invalidCharCountEmail.isEmpty {
                            Text(viewModel.invalidCharCountEmail)
                                .frame(width: screen.width - 40, height: 10, alignment: .center)
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        } else {
                            if !viewModel.invalidEmail.isEmpty {
                                Text(viewModel.invalidEmail)
                                    .frame(width: screen.width - 40, height: 10, alignment: .leading)
                                    .foregroundColor(.red)
                                    .padding(.top, 5)
                            }
                        }
                    }
                }
            }
            Spacer().frame(height: 20)
        }
    }

    struct PasswordField: View {
        @State var screen: CGSize?
        @ObservedObject var viewModel: LoginViewModel
        
        var body:some View {
            HStack {
                Image(systemName: "key.fill").frame(width: 20, height: 10, alignment: .center)
                SecureField("password", text: $viewModel.password)
                    .textFieldStyle(PlainTextFieldStyle())
                    .onChange(of: viewModel.password) { _ in
                        viewModel.hasChangedPassword = true
                    }.foregroundColor(.gray)
            }.underlineTextField().padding(.horizontal, 20)
            if let screen = screen {
                if viewModel.hasChangedPassword {
                    if !viewModel.isEmptyPassword.isEmpty {
                        Text(viewModel.isEmptyPassword)
                            .frame(width: screen.width - 40, height: 10, alignment: .leading)
                            .foregroundColor(.red)
                            .padding(.top, 5)
                    } else {
                        if !viewModel.invalidCharCountPassword.isEmpty {
                            Text(viewModel.invalidCharCountPassword)
                                .frame(width: screen.width - 40, height: 10, alignment: .leading)
                                .foregroundColor(.red)
                                .padding(.top, 5)
                        }
                    }
                }
            }
            Spacer().frame(height: 20)
        }
    }
    
    func login() {
        guard let url = URL(string: "https://my-json-server.typicode.com/f-rm/SwiftUITraining/login") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params:[String:Any] = [
            "email": viewModel.email,
            "password": viewModel.password,
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(LoginResponse.self, from: data) {
                    print(response)
                    if let id = response.id {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }.resume()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
