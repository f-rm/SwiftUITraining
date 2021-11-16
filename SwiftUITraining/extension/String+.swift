//
//  String+.swift
//  SwiftUITraining
//
//  Created by f-rm on 2021/11/16.
//

import Foundation

extension String {
    
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var isOver8Charctor: Bool {
        return self.count >= 8
    }
    
    var isWithin50Charctor: Bool {
        return self.count <= 50
    }
    
}
