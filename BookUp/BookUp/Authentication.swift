//
//  Authentication.swift
//  BookUp
//
//  Created by Lydia on 11/17/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import Foundation
import FirebaseAuth

import UIKit
class Authentication {
    
    //https://www.iosapptemplates.com/blog/swift-programming/firebase-swift-tutorial-login-registration-ios

//    func createUser(email: String, password: String, completionBlock: @escaping (_ success: Bool) -> Void) {
//        Auth.auth().createUser(withEmail: email, password: password) {(authResult, error) in
//            if let user = authResult?.user {
//                print(user)
//                completionBlock(true)
//            } else {
//                completionBlock(false)
//            }
//        }
//    }
    func createUser(email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                return
            }
            callback?(nil)
        }
    }
    func login(withEmail email: String, password: String, _ callback: ((Error?) -> ())? = nil){
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if let e = error{
                callback?(e)
                return
            }
            callback?(nil)
        }
    }
    func signIn(email: String, pass: String, completionBlock: @escaping (_ success: Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: pass) { (result, error) in
            if let error = error, let _ = AuthErrorCode(rawValue: error._code) {
                completionBlock(false)
            } else {
                completionBlock(true)
            }
        }
    }
    
    func signOut() -> Bool{
        do{
            try Auth.auth().signOut()
            return true
        }catch{
            return false
        }
    }
    
    
    
    func sendEmailVerification(_ callback: ((Error?) -> ())? = nil){
        Auth.auth().currentUser?.sendEmailVerification(completion: { (error) in
            callback?(error)
        })
    }
}
