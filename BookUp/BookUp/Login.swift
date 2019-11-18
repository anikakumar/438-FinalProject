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
    //https://www.appcoda.com/firebase-login-signup/
    
    @IBAction func login(_ sender: UIButton) {
        //https://www.appcoda.com/firebase-login-signup/
        guard let email = username.text, let password = password.text else { return }
        if (email == "" && password == ""){
            let alert = UIAlertController(title: "Failure to Login", message: "Email and password fields are blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if(email == ""){
            let alert = UIAlertController(title: "Failure to Login", message: "Email field is blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if (password == ""){
            let alert = UIAlertController(title: "Failure to Login", message: "Password field is blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
        else if email.range(of: #"@wustl.edu"#, options: .regularExpression) != nil {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                if error == nil {
                    print("You have successfully logged in")
                    self.loadHomeScreen()
                } else {
                    print ("haha no")
                }
            }
        }
        else{
            let alert = UIAlertController(title: "Failure to Login", message: "Invalid credientials provided", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
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


