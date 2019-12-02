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
    
    @IBOutlet weak var listingsLabel: UILabel!
    var myPosts: [Book] = []
    var idToBook: [String: Book] = [:]
    var imageCache: [UIImage] = []
    
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
                            self.idToBook[document.documentID] = haha
                            let url = URL(string: haha.Picture)
                            let data = try? Data(contentsOf: url!)
                            let image = UIImage(data: data!)!
                            self.imageCache.append(image)
                        }
                    }
                    catch{
                        print(error)
                    }
                }
            }
            if (self.myPosts == []){
                self.listingsLabel.text = "You have no listings yet. Go to the sell tab to post a listing!"
                self.listingsLabel.adjustsFontSizeToFitWidth = true
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
        cell.configure(i: imageCache[indexPath.row], l: myPosts[indexPath.row].BookTitle)
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let iPath = self.myBooks.indexPathsForSelectedItems
        let indexPath : IndexPath = iPath![0] as IndexPath
        if segue.identifier == "postedDetail" {
            let detailVC = segue.destination as! BrowseDetails
            detailVC.bt = myPosts[indexPath.row].BookTitle
            detailVC.a = myPosts[indexPath.row].Author
            detailVC.s = myPosts[indexPath.row].Seller
            detailVC.p = String(myPosts[indexPath.row].Price)
            detailVC.course = myPosts[indexPath.row].Course
            detailVC.comm = myPosts[indexPath.row].Comments
            detailVC.cond = myPosts[indexPath.row].Condition
            detailVC.v = myPosts[indexPath.row].Version
            detailVC.isbn = myPosts[indexPath.row].ISBN
            let url = URL(string: myPosts[indexPath.row].Picture)
            let data = try? Data(contentsOf: url!)
            let image = UIImage(data: data!)!
            detailVC.bookpic = image
            var idToAppend: String = ""
            for (bookID, bookObj) in idToBook {
                if bookObj == myPosts[indexPath.row] {
                    idToAppend = bookID
                    detailVC.refString = idToAppend
                }
            }
        }
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myPosts = []
        idToBook = [:]
        grabFirebaseData()
        grabBookData()
        myBooks.reloadData()
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
                    print (error)
                }
            }
        }
    }
}

