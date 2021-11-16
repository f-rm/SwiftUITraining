//
//  UserRegistViewModel.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/08/31.
//

import Foundation
import Combine

class UserRegistViewModel: ObservableObject {
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var isEmptyFirstname: String = ""
    @Published var isEmptyLastname: String = ""
    @Published var isEmptyEmail: String = ""
    @Published var isEmptyPassword: String = ""
    @Published var isEmptyConfirmPassword: String = ""
    
    @Published var invalidCharCountFirstname: String = ""
    @Published var invalidCharCountLastname: String = ""
    @Published var invalidCharCountEmail: String = ""
    @Published var invalidCharCountPassword: String = ""
    @Published var invalidCharCountConfirmPassword: String = ""
    
    @Published var invalidEmail: String = ""
    @Published var invalidPassword: String = ""
    
    @Published var isValidNameInput = false
    @Published var isValidPasswordInput = false
    @Published var isValidInput = false
    
    var hasChangedFirstname = false
    var hasChangedLastname = false
    var hasChangedEmail = false
    var hasChangedPassword = false
    var hasChangedConfirmPassword = false
    
    init() {
        
        let firstNameValidation = $firstName.map({ !$0.isEmpty && $0.isWithin50Charctor }).eraseToAnyPublisher()
        let lastNameValidation = $lastName.map({ !$0.isEmpty && $0.isWithin50Charctor }).eraseToAnyPublisher()
        let emailValidation = $email.map({ !$0.isEmpty && $0.isWithin50Charctor && $0.isValidEmail }).eraseToAnyPublisher()
        let passwordValidation = $password.map({ !$0.isEmpty && $0.isOver8Charctor && $0.isWithin50Charctor }).eraseToAnyPublisher()
        let confirmPasswordValidation = $confirmPassword.map({ !$0.isEmpty && $0.isOver8Charctor && $0.isWithin50Charctor }).eraseToAnyPublisher()
        
        let nameInputValidation = $isValidNameInput.map({$0 == true}).eraseToAnyPublisher()
        let passwordInputValidation = $isValidPasswordInput.map({$0 == true}).eraseToAnyPublisher()
        
        Publishers.CombineLatest(firstNameValidation, lastNameValidation)
            .map({ [$0.0, $0.1] })
            .map({ $0.allSatisfy({ $0 })})
            .assign(to: &$isValidNameInput)
        
        Publishers.CombineLatest(passwordValidation, confirmPasswordValidation)
            .map({ [$0.0, $0.1] })
            .map({ $0.allSatisfy({ $0 })})
            .assign(to: &$isValidPasswordInput)
        
        Publishers.CombineLatest3(nameInputValidation, passwordInputValidation, emailValidation)
            .map({ [$0.0, $0.1, $0.2] })
            .map({ $0.allSatisfy({ $0 })})
            .assign(to: &$isValidInput)
        
        $firstName.map({ !$0.isEmpty ? "" : "first name is empty" }).assign(to: &$isEmptyFirstname)
        $lastName.map({ !$0.isEmpty ? "" : "last name is empty" }).assign(to: &$isEmptyLastname)
        $email.map({ !$0.isEmpty ? "" : "email is empty" }).assign(to: &$isEmptyEmail)
        $password.map({ !$0.isEmpty ? "" : "password is empty" }).assign(to: &$isEmptyPassword)
        $confirmPassword.map({ !$0.isEmpty ? "" : "confirm password is empty" }).assign(to: &$isEmptyConfirmPassword)
        
        $firstName.map({ $0.isWithin50Charctor ? "" : "firstName must be within 50 characters" }).assign(to: &$invalidCharCountFirstname)
        $lastName.map({ $0.isWithin50Charctor ? "" : "lastName must be within 50 characters" }).assign(to: &$invalidCharCountLastname)
        $email.map({ $0.isWithin50Charctor ? "" : "email must be within 50 characters" }).assign(to: &$invalidCharCountEmail)
        $password.map({ $0.isOver8Charctor && $0.isWithin50Charctor ? "" : "password must be 8-50 characters" }).assign(to: &$invalidCharCountPassword)
        $confirmPassword.map({ $0.isOver8Charctor && $0.isWithin50Charctor ? "" : "confirmPassword must be 8-50 characters" }).assign(to: &$invalidCharCountConfirmPassword)
        
        $email.map({ $0.isValidEmail ? "" : "email is invalid" }).assign(to: &$invalidEmail)
    }
}
