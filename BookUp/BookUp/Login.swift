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
        //https://www.appcoda.com/firebase-login-signup/
        let loginManager = Authentication()
        guard let email = username.text, let password = password.text else { return }
        if let match = email.range(of: #"@wustl.edu"#, options: .regularExpression) {
            Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                
                if error == nil {
                    
                    //Print into the console if successfully logged in
                    print("You have successfully logged in")
                    self.loadHomeScreen()
                    
                    //Go to the HomeViewController if the login is sucessful
//                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
//                    self.present(vc!, animated: true, completion: nil)
                    
                } else {
                    
                    //Tells the user that there is an error and then gets firebase to tell them the error
//                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
//
//                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
//                    alertController.addAction(defaultAction)
//
//                    self.present(alertController, animated: true, completion: nil)
                    print ("haha no")
                }
            }
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


