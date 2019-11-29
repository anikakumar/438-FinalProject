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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:Cell = self.recent.dequeueReusableCell(withIdentifier: "recentlyViewed", for: indexPath) as! Cell

        let url = URL(string: recentBooks[indexPath.row].Picture)
        let data = try? Data(contentsOf: url!)
        let image = UIImage(data: data!)!
        cell.configure(i: image, l1: recentBooks[indexPath.row].BookTitle, l2: recentBooks[indexPath.row].Course , l3: "$" + String(recentBooks[indexPath.row].Price), id: indexPath.row)
        print(recentBooks)
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
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
        print("entered history view did load")
        recent.delegate = self
        recent.dataSource = self
        grabFirebaseData()
        self.recent.isHidden = false
        self.recent.reloadData()
    }
    
    //books sold
    //books listed
    //contacted by

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
                    print ("something went wrong")
                }
            }
        }
        self.recent.reloadData()
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
                            let haha = try JSONDecoder().decode(Book.self, from: jsonData!)
                            self.recentBooks.append(haha)
                        }
                    }
                    catch{
                        print(error)
                    }
                }
                print("------HISTORY OVER--------")
            }
            //            print(self.bookResults)
            self.recent.reloadData()
        }
    }
//
//    func grabBookData() {
//        print("------HISTORY--------")
//        for r in recents {
//           print(r)
//        }
//        print("------HISTORY OVER--------")
//    }
}

