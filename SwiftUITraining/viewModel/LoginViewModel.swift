//
//  LoginViewModel.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/31.
//

import Foundation
import Combine

class LoginViewModel: ObservableObject {
    
    @Published var email = "test@test.com"
    @Published var password = "test1234"
    @Published var isEmptyEmail = ""
    @Published var isEmptyPassword = ""
    @Published var invalidCharCountEmail = ""
    @Published var invalidCharCountPassword = ""
    @Published var invalidEmail = ""
    
    @Published var isValidInput = false
    
    var hasChangedEmail = false
    var hasChangedPassword = false
    
    init() {
        let mailValidation = $email.map({ !$0.isEmpty && $0.isWithin50Charctor && $0.isValidEmail }).eraseToAnyPublisher()
        let passValidation = $password.map({ !$0.isEmpty && $0.isOver8Charctor }).eraseToAnyPublisher()
        
        Publishers.CombineLatest(mailValidation, passValidation)
            .map({ [$0.0, $0.1] })
            .map({ $0.allSatisfy({ $0 })})
            .assign(to: &$isValidInput)
        
        $email.map({ !$0.isEmpty ? "" : "email is empty" }).assign(to: &$isEmptyEmail)
        
        $email.map({ $0.isWithin50Charctor ? "" : "email must be within 50 characters" }).assign(to: &$invalidCharCountEmail)
        
        $email.map({ $0.isValidEmail ? "" : "email is invalid" }).assign(to: &$invalidEmail)
        
        $password.map({ !$0.isEmpty ? "" : "password is empty" }).assign(to: &$isEmptyPassword)
        
        $password.map({ $0.isOver8Charctor && $0.isWithin50Charctor ? "" : "password must be 8-50 characters" }).assign(to: &$invalidCharCountPassword)
    }
}
