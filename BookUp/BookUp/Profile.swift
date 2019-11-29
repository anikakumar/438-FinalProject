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

class Profile: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var myPosts: [Book] = []
    
    func grabBookData() {
        let db = Firestore.firestore()
        db.collection("/Postings/").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var m =  document.data() as [String:AnyObject]
                    m.removeValue(forKey: "DatePosted")
                    let jsonData = try? JSONSerialization.data(withJSONObject:m)
                    do{
                        let haha = try JSONDecoder().decode(Book.self, from: jsonData!)
                        if haha.Seller == self.username {
                            self.myPosts.append(haha)
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }
            print(self.myPosts.count)
            self.myBooks.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myPosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:Cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "myPostings", for: indexPath) as! Cell2
        //cell.backgroundColor = UIColor.black
        let url = URL(string: myPosts[indexPath.row].Picture)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)!
        print(myPosts[indexPath.row].BookTitle)
        cell.configure(i: image, l: myPosts[indexPath.row].BookTitle)
        return cell
    }
    
    
    @IBOutlet var myBooks: UICollectionView!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var image: UIImageView!
    let db = Firestore.firestore()
    var username = String((Auth.auth().currentUser?.email?.dropLast(10))!)
    
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
        myBooks.delegate = self
        myBooks.dataSource = self
        grabFirebaseData()
        grabBookData()
    }
    
    func grabFirebaseData() {
        db.collection("/Users/").document(username).getDocument { (document, error) in
            if let document = document, document.exists{
                let data = document.data()
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject: data!)
                    let user = try JSONDecoder().decode(User.self, from: jsonData!)
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

