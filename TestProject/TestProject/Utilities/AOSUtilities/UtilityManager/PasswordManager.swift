//
//  PasswordManager.swift
//  Atticus
//
//  Created by Comnet India on 11/10/19.
//  Copyright © 2019 Comnet India. All rights reserved.
//

import UIKit
import Foundation
import RNCryptor

/// Description : This class is used for manage password with encryption
class PasswordManager: NSObject {
    
    /// Description : Shared Instance method for global access
    public class var sharedInstance : PasswordManager {
        struct Static {
            static let instance : PasswordManager = PasswordManager()
        }
        return Static.instance
    }
    
    /// Description : This function is used for encrypt the password
    /// - Parameter passString: password need to be encrypted
    func encryptLoginPassword(passString:String) -> String
       {
           let cryptLib = CryptLib()
           var iv = ""
           let key = cryptLib.sha256("atractionoperationsystemcnsindia", length: 32)
           if let randomIV = cryptLib.generateRandomIV(16){
               print("randomIV : \(randomIV)")
               iv = randomIV
           }
      
           if let s = cryptLib.encrypt(passString.data(using: .utf8), key: key, iv: iv)?.base64EncodedString(){
               return s + "WORD2132" + iv
           }
           return ""
       }
}
