//
//  History.swift
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

class History: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var recents: [String] = []
    var recentBooks: [Book] = []
    var imageCache: [UIImage] = []
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:Cell = self.recent.dequeueReusableCell(withIdentifier: "recentlyViewed", for: indexPath) as! Cell

        cell.configure(i: imageCache[indexPath.row], l1: recentBooks[indexPath.row].BookTitle, l2: recentBooks[indexPath.row].Course , l3: "$" + String(recentBooks[indexPath.row].Price), id: indexPath.row)
         cell.textLabel?.adjustsFontSizeToFitWidth = true
        return cell
        
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = BrowseDetails()
        detailVC.bt = recentBooks[indexPath.row].BookTitle
        detailVC.a = recentBooks[indexPath.row].Author
        detailVC.s = recentBooks[indexPath.row].Seller
        detailVC.p = String(recentBooks[indexPath.row].Price)
        detailVC.course = recentBooks[indexPath.row].Course
        detailVC.comm = recentBooks[indexPath.row].Comments
        detailVC.cond = recentBooks[indexPath.row].Condition
        detailVC.v = recentBooks[indexPath.row].Version
        detailVC.isbn = recentBooks[indexPath.row].ISBN
        let url = URL(string: recentBooks[indexPath.row].Picture)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)!
        detailVC.bookpic = image
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        recent.delegate = self
        recent.dataSource = self
        self.recent.isHidden = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            recents = []
            recentBooks = []
            imageCache = []
            grabFirebaseData()
    }

    @IBOutlet weak var recent: UITableView!
    
    var username = String((Auth.auth().currentUser?.email?.dropLast(10))!)
    
    func grabFirebaseData() {
        Firestore.firestore().collection("/Users/").document(username).getDocument { (document, error) in
            if let document = document, document.exists{
                let data = document.data()
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject: data!)
                    let user = try JSONDecoder().decode(User.self, from: jsonData!)
                    self.recents = user.RecentlyViewed
                    self.grabFirebaseDataPosts()
                } catch {
                    print (error)
                }
            }
        }
    }
    
    
    func grabFirebaseDataPosts() {
        let db = Firestore.firestore()
        db.collection("/Postings/").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                print("------HISTORY--------")
                for document in querySnapshot!.documents {
                    var m =  document.data() as [String:AnyObject]
                    m.removeValue(forKey: "DatePosted")
                    let jsonData = try? JSONSerialization.data(withJSONObject:m)
                    do{
                        if self.recents.contains(document.documentID) {
                            print("DOCUMENT ID", document.documentID)
                            let haha = try JSONDecoder().decode(Book.self, from: jsonData!)
                            self.recentBooks.append(haha)
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
                print("------HISTORY OVER--------")

            }
            self.recent.reloadData()
        }
    }

    @IBAction func clear(_ sender: Any) {
        let db = Firestore.firestore()
        let username = String((Auth.auth().currentUser?.email?.dropLast(10))!)
        db.collection("/Users/").document(username).updateData([
            "RecentlyViewed" : []
        ])
        recents = []
        recentBooks = []
        imageCache = []
        self.recent.reloadData()
    }
}

