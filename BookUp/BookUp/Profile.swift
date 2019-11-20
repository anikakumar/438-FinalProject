//
//  Profile.swift
//  BookUp
//
//  Created by Davari on 11/11/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore
import FirebaseCore

class Profile: UIViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var image: UIImageView!
    let db = Firestore.firestore()
    var username = String((Auth.auth().currentUser?.email?.dropLast(10))!)
//    var thisUser: User = User(ProfilePic: "", Email: "", FirstName: "", LastName: "", RecentlyViewed: [""])
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        firstName.isUserInteractionEnabled = !firstName.isUserInteractionEnabled
        lastName.isUserInteractionEnabled = !lastName.isUserInteractionEnabled
        editButton.title = (firstName.isUserInteractionEnabled) ? "Save" : "Edit"
        if editButton.title == "Edit" {
            //                if firstName.text != nil && lastName.text != nil {
            print("write to database")
            db.collection("/Users/").document(username).updateData([
                "FirstName" : firstName.text!,
                "LastName" : lastName.text!
                ])
        }
    }
    
    @IBAction func logout(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let logInViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! UINavigationController
            self.present(logInViewController, animated: true, completion: nil)
            print("signed out")
        }
        catch{
            print("didn't sign out")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        grabFirebaseData()
    }
    
    func grabFirebaseData() {
        db.collection("/Users/").document(username).getDocument { (document, error) in
            if let document = document, document.exists{
                let data = document.data()
                //                    .map(String.init(describing:)) ?? "nil"
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject: data!)
                    let user = try JSONDecoder().decode(User.self, from: jsonData!)
//                    self.thisUser = user
                    let url = URL(string: user.ProfilePic)
                    let data = try? Data(contentsOf: url!)
                    let imageImage = UIImage(data: data!)!
                    self.firstName.text = user.FirstName
                    self.lastName.text = user.LastName
                    self.email.text = "Email: " +  user.Email
                    self.image.image = imageImage
                } catch {
                    print ("something went wrong")
                }
            }
        }
    }
    
    //name
    //email
    //update button
    //your listings
}

