//
//  ValidationManager.swift
//  Atticus
//
//  Created by Comnet India on 11/10/19.
//  Copyright © 2019 Comnet India. All rights reserved.
//

import UIKit

/// Description : This is validating class which contains diffrent types of validation code
class ValidationManager: NSObject {
    
    
    /// Description : Shared Instance method for global access
    public class var sharedInstance : ValidationManager {
        struct Static {
            static let instance : ValidationManager = ValidationManager()
        }
        return Static.instance
    }
    
    
    /// Description : This function is used for validate email address
    /// - Parameter testStr: textfeild string containing email address
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    /// Description : This function is used for validate the phone number
    /// - Parameter value: textfeild string containing phone number
    func isValidPhone(value: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}-\\d{3}-\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result =  phoneTest.evaluate(with: value)
        return result
    }
    
    func isValidatePresence(string: String) -> Bool {
        let trimmed: String = string.trimmingCharacters(in: CharacterSet.whitespaces)
        return !trimmed.isEmpty
    }
    
    /// Description : This function is used for check valid password
    /// - Parameter string: strPassword
    func isValidPassword(string: String) -> Bool  {
        guard string.count >= 6 else { return false }
        let lowerCaseRegEx = ".*[a-z].*"
        let lowerCaseTest = NSPredicate(format:"SELF MATCHES %@", lowerCaseRegEx).evaluate(with: string.lowercased())
        let digitRegEx = ".*[0-9].*"
        let digitTest = NSPredicate(format:"SELF MATCHES %@", digitRegEx).evaluate(with: string)
        return  lowerCaseTest && digitTest
    }
}
