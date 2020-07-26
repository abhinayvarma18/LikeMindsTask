//
//  FirebaseAuthManager.swift
//  Wassup
//
//  Created by abhinay varma on 26/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import Foundation
import FirebaseAuth

final class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    
    func verifyPhone(withPhoneNumber:String, completion:((Error?)->Void)?) {
       // Auth.auth().languageCode = "en";
        PhoneAuthProvider.provider().verifyPhoneNumber(withPhoneNumber, uiDelegate: nil) { (verificationID, error) in
          if let error = error {
            //self.showMessagePrompt(error.localizedDescription)
            completion?(error)
            return
          }
          UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
          UserDefaults.standard.set(withPhoneNumber, forKey: "phoneNumber")
          completion?(nil)
        }
    }
    
    func signIn(withOTP:String, completion:((Error?)->Void)?) {
        let verificationID = UserDefaults.standard.string(forKey: "authVerificationID") ?? ""
        let credential = PhoneAuthProvider.provider().credential(
        withVerificationID: verificationID,
        verificationCode: withOTP)
        
        Auth.auth().signIn(with: credential) { (authResult, error) in
          if let error = error {
            let authError = error as NSError
            if (authError.code == AuthErrorCode.secondFactorRequired.rawValue) {
              // The user is a multi-factor user. Second factor challenge is required.
              let resolver = authError.userInfo[AuthErrorUserInfoMultiFactorResolverKey] as! MultiFactorResolver
              var displayNameString = ""
              for tmpFactorInfo in (resolver.hints) {
                displayNameString += tmpFactorInfo.displayName ?? ""
                displayNameString += " "
              }
              completion?(error)
            } else {
              completion?(error)
              return
            }
            // ...
            completion?(error)
            return
          }
          completion?(nil)
        }
    }
}
