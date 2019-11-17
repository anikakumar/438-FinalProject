//
//  Login.swift
//  BookUp
//
//  Created by Lydia on 11/17/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import UIKit
import FirebaseAuth

class Login: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    //https://www.iosapptemplates.com/blog/swift-programming/firebase-swift-tutorial-login-registration-ios
    
    @IBAction func login(_ sender: UIButton) {
        
        let loginManager = Authentication()
        guard let email = username.text, let password = password.text else { return }
        if let match = email.range(of: #"@wustl.edu"#, options: .regularExpression) {
            //            print("wustl email: " + email)
            //            print("password: " + password)
            //            print("this would theoretically attempt to log in")
//            loginManager.signIn(email: email, pass: password) {[weak self] (success) in
//                guard let `self` = self else { return }
//                var message: String = ""
//                if (success) {
                    loadHomeScreen()
//                    message = "User was sucessfully logged in."
//                } else {
//                    message = "There was an error."
//                }
                //                //                let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                //                //                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                //                //                self.display(alertController: alertController)
                //            }
                //        }
                //        else {
                //            print("email: " + email)
                //            print("password: " + password)
                //            let alert = UIAlertController(title: "Error", message: "The login you have entered is not valid", preferredStyle: .alert)
                //            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                //                NSLog("The \"OK\" alert occured.")
                //            }))
                //            self.present(alert, animated: true, completion: nil)
                //        }
//            }
            
        }
    }
    @IBAction func createAccount(_ sender: UIButton) {
        
    }
    
    //https://www.back4app.com/docs/ios/swift-login-tutorial
    func loadHomeScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Search") as! UITabBarController
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    
    
}

/*
 // MARK: - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
 // Get the new view controller using segue.destination.
 // Pass the selected object to the new view controller.
 }
 */


