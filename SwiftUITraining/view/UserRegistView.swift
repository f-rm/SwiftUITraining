//
//  UserRegistView.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/23.
//

import SwiftUI

struct UserRegistView: View {
    
    @State var screen: CGSize?
    @State var showingPicker = false
    @State var isShowRegistAlert = false
    @State var userImage: UIImage?
    @ObservedObject var viewModel: UserRegistViewModel = .init()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center) {
                    Group {
                        ZStack(alignment: .bottomTrailing) {
                            if let userImage = userImage {
                                Image(uiImage: userImage)
                                    .resizable()
                                    .frame(width: 200, height: 200, alignment: .center)
                                    .clipShape(Circle())
                                    .shadow(radius: 20)
                            } else {
                                Image("user")
                                    .resizable()
                                    .frame(width: 200, height: 200, alignment: .center)
                                    .clipShape(Circle())
                                    .shadow(radius: 20)
                            }
                            Image("camera")
                                .resizable()
                                .frame(width: 30, height: 30, alignment: .center)
                                .background(Color.white)
                                .clipShape(Circle())
                                .offset(x: -13, y: -13)
                                .onTapGesture {
                                    showingPicker.toggle()
                                }
                        }
                    }
                    Spacer().frame(height: 20)
                    Group {
                        if let screen = screen {
                            FirstNameField(screen: screen, viewModel: viewModel)
                            LastNameField(screen: screen, viewModel: viewModel)
                            EmailField(screen: screen, viewModel: viewModel)
                            PasswordField(screen: screen, viewModel: viewModel)
                            ConfirmPasswordField(screen: screen, viewModel: viewModel)
                        }
                    }
                    Spacer().frame(height: 60)
                    Group {
                        Button(action: {
                            print("regist button pressed!")
                            registUser()
                        } ) {
                            Text("regist")
                                .foregroundColor(Color.white)
                                .frame(width: 300, height: 20, alignment: .center)
                                .padding()
                                .background(self.viewModel.isValidInput ? Color.blue :  Color.black.opacity(0.3))
                                .cornerRadius(100)
                        }.frame(width: 300, height: 20, alignment: .center)
                        .disabled(!self.viewModel.isValidInput)
                    }
                }.frame(alignment: .top)
                .navigationTitle("user regist")
                .navigationBarItems(
                    leading:
                        Button("close", action: {
                            self.presentationMode.wrappedValue.dismiss()
                        })
                ).alert(isPresented: self.$isShowRegistAlert, content: {
                    Alert(title: Text("notice"),
                          message: Text("user has registered."),
                          dismissButton: .default(Text("OK"), action: {
                            self.presentationMode.wrappedValue.dismiss()
                          }))
                })
            }
        }.onAppear(){
            screen = UIScreen.main.bounds.size
        }
        .sheet(isPresented: $showingPicker) {
            PHImagePicker(image: $userImage, picker: $showingPicker)
        }
    }
    
    func registUser() {
        guard let url = URL(string: "https://my-json-server.typicode.com/f-rm/SwiftUITraining/regist") else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let params:[String:Any] = [
            "name": viewModel.firstName + " " + viewModel.lastName,
            "job": "engineer",
        ]
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let response = try? JSONDecoder().decode(UserRegistResponse.self, from: data) {
                    print(response)
                    self.isShowRegistAlert = true
                }
            }
        }.resume()
    }
}

extension View {
    func underlineTextField() -> some View {
        self
            .overlay(Rectangle().frame(height: 1).padding(.top, 35))
            .foregroundColor( Color(red: 195/255, green: 195/255, blue: 195/255, opacity: 1.0))
    }
}

struct FirstNameField: View {
    @State var screen: CGSize?
    @ObservedObject var viewModel: UserRegistViewModel
    
    var body:some View {
        HStack {
            Image(systemName: "person.fill").frame(width: 20, height: 10, alignment: .center)
            TextField("first name", text: $viewModel.firstName)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: viewModel.firstName) { firstName in
                    viewModel.hasChangedFirstname = true
                }
        }.underlineTextField().padding(.horizontal, 20)
        if let screen = screen {
            if viewModel.hasChangedFirstname {
                if !viewModel.isEmptyFirstname.isEmpty {
                    Text(viewModel.isEmptyFirstname)
                        .frame(width: screen.width - 40, height: 10, alignment: .leading)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                } else {
                    if !viewModel.invalidCharCountFirstname.isEmpty {
                        Text(viewModel.invalidCharCountFirstname)
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

struct LastNameField: View {
    @State var screen: CGSize?
    @ObservedObject var viewModel: UserRegistViewModel
    
    var body:some View {
        HStack {
            Image(systemName: "person.fill").frame(width: 20, height: 10, alignment: .center)
            TextField("last name", text: $viewModel.lastName)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: viewModel.lastName) { _ in
                    viewModel.hasChangedLastname = true
                }
        }.underlineTextField().padding(.horizontal, 20)
        if let screen = screen {
            if viewModel.hasChangedLastname {
                if !viewModel.isEmptyLastname.isEmpty {
                    Text(viewModel.isEmptyLastname)
                        .frame(width: screen.width - 40, height: 10, alignment: .leading)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                } else {
                    if !viewModel.invalidCharCountLastname.isEmpty {
                        Text(viewModel.invalidCharCountLastname)
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

struct EmailField: View {
    @State var screen: CGSize?
    @ObservedObject var viewModel: UserRegistViewModel
    
    var body:some View {
        HStack {
            Image(systemName: "envelope.fill").frame(width: 20, height: 10, alignment: .center)
            TextField("email", text: $viewModel.email)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: viewModel.email) { _ in
                    viewModel.hasChangedEmail = true
                }
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
                            .frame(width: screen.width - 40, height: 10, alignment: .leading)
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
    @ObservedObject var viewModel: UserRegistViewModel
    
    var body:some View {
        HStack {
            Image(systemName: "key.fill").frame(width: 20, height: 10, alignment: .center)
            SecureField("password", text: $viewModel.password)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: viewModel.password) { _ in
                    viewModel.hasChangedPassword = true
                }
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

struct ConfirmPasswordField: View {
    @State var screen: CGSize?
    @ObservedObject var viewModel: UserRegistViewModel
    
    var body:some View {
        HStack {
            Image(systemName: "key.fill").frame(width: 20, height: 10, alignment: .center)
            SecureField("confirm password", text: $viewModel.confirmPassword)
                .textFieldStyle(PlainTextFieldStyle())
                .onChange(of: viewModel.confirmPassword) { _ in
                    viewModel.hasChangedConfirmPassword = true
                }
        }.underlineTextField().padding(.horizontal, 20)
        if let screen = screen {
            if viewModel.hasChangedConfirmPassword {
                if !viewModel.isEmptyConfirmPassword.isEmpty {
                    Text(viewModel.isEmptyConfirmPassword)
                        .frame(width: screen.width - 40, height: 10, alignment: .leading)
                        .foregroundColor(.red)
                        .padding(.top, 5)
                } else {
                    if !viewModel.invalidCharCountConfirmPassword.isEmpty {
                        Text(viewModel.invalidCharCountConfirmPassword)
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

struct UserRegistView_Previews: PreviewProvider {
    static var previews: some View {
        UserRegistView()
    }
}
