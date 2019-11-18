//
//  CreateAccount.swift
//  BookUp
//
//  Created by Lydia on 11/17/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseCore

class CreateAccount: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verify: UITextField!

    
    //https://www.appcoda.com/firebase-login-signup/
    @IBAction func create(_ sender: UIButton) {
        password.textContentType = UITextContentType(rawValue: "")
        verify.textContentType = UITextContentType(rawValue: "")
        if firstName.text != "", lastName.text != "", username.text != "", password.text != "", verify.text != "" {
            if password.text == verify.text {
                guard let email = username.text, let password = password.text else { return }
                if email.range(of: #"@wustl.edu"#, options: .regularExpression) != nil {
                    print("e" + email)
                    print("p" + password)
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if error == nil {
                            print("You have successfully signed up")
                            //write to the database First Name, Last Name, email, pic
                            Firestore.firestore().collection("Users").document(String(email.dropLast(10))).setData([
                                "FirstName": self.firstName.text!,
                                "LastName": self.lastName.text!,
                                "Email": email,
                                "ProfilePic": "https://www.daarts.org/wp-content/uploads/2019/02/individual.png"
                                ])
                            self.loadHomeScreen()
                        } else {
                            let alert = UIAlertController(title: "Failure to Create Account", message: "Email is already associated with an account", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                                NSLog("The \"OK\" alert occured.")
                            }))
                            self.present(alert, animated: true, completion: nil)
                            self.username.text = ""
                        }
                    }
                }
                else{
                    let alert = UIAlertController(title: "Failure to Create Account", message: "Please use a WashU email address.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            } else {
                let alert = UIAlertController(title: "Failure to Create Account", message: "Passwords do not match.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
                self.verify.text = ""
            }
        } else {
            let alert = UIAlertController(title: "Failure to Create Account", message: "At least one field is left blank", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //https://www.back4app.com/docs/ios/swift-login-tutorial
    func loadHomeScreen(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loggedInViewController = storyBoard.instantiateViewController(withIdentifier: "Search") as! UITabBarController
        self.present(loggedInViewController, animated: true, completion: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
