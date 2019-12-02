//
//  Browse.swift
//  BookUp
//
//  Created by Davari on 11/11/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class Browse: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource {
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:Cell = self.tableView.dequeueReusableCell(withIdentifier: "myBook", for: indexPath) as! Cell
        print(cell)
        cell.configure(i: imageCache[indexPath.row], l1: bookResults[indexPath.row].BookTitle, l2: bookResults[indexPath.row].Course , l3: "$" + String(bookResults[indexPath.row].Price), id: indexPath.row)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        cell.label1.adjustsFontSizeToFitWidth = true
        cell.label2.adjustsFontSizeToFitWidth = true
        cell.label3.adjustsFontSizeToFitWidth = true
        
      
        return cell
    }
    
    @IBOutlet var search: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    var bookResults: [Book] = []
    var b: Book!
    var everyBook: [Book] = []
    var idToBook: [String: Book] = [:]
    var imageCache: [UIImage] = []
    var allImages: [UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        grabFirebaseData()
        // Do any additional setup after loading the view.
    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        print("start display")
//        everyBook = []
//        bookResults = []
//        imageCache = []
//        allImages = []
//        grabFirebaseData()
//        print("displayed")
//    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        bookResults = []
        imageCache = []
        if (searchBar.text! == ""){
            bookResults = everyBook
            imageCache = allImages
        } else {
            for book in everyBook {
                if book.BookTitle.lowercased().contains(searchBar.text!.lowercased()) || book.Author.lowercased().contains(searchBar.text!.lowercased()) || book.Course.lowercased().contains(searchBar.text!.lowercased()){
                    bookResults.append(book)
                    let url = URL(string: book.Picture)
                    let data = try? Data(contentsOf: url!)
                    let image = UIImage(data: data!)!
                    self.imageCache.append(image)
                }
            }
        }
//        print(bookResults)
        self.tableView.reloadData()
    }
    
    @IBAction func refresh(_ sender: Any) {
        everyBook = []
        bookResults = []
        imageCache = []
        allImages = []
        grabFirebaseData()
    }
    
    var recents: [String] = []
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let detailVC = segue.destination as! BrowseDetails
                detailVC.bt = bookResults[indexPath.row].BookTitle
                detailVC.a = bookResults[indexPath.row].Author
                detailVC.s = bookResults[indexPath.row].Seller
                detailVC.p = String(bookResults[indexPath.row].Price)
                detailVC.course = bookResults[indexPath.row].Course
                detailVC.comm = bookResults[indexPath.row].Comments
                detailVC.cond = bookResults[indexPath.row].Condition
                detailVC.v = bookResults[indexPath.row].Version
                detailVC.isbn = bookResults[indexPath.row].ISBN
                detailVC.bookpic = imageCache[indexPath.row]
                
                var idToAppend: String = ""
                for (bookID, bookObj) in idToBook {
                    if bookObj == bookResults[indexPath.row] {
                        idToAppend = bookID
                        detailVC.refString = idToAppend
                    }
                }
                let db = Firestore.firestore()
                let username = String((Auth.auth().currentUser?.email?.dropLast(10))!)
                db.collection("/Users/").document(username).updateData([
                    "RecentlyViewed" : FieldValue.arrayUnion([idToAppend])
                ])
            }
        }
    }

    func grabFirebaseDataRecentlyViewed(){
        let username = String((Auth.auth().currentUser?.email?.dropLast(10))!)
        Firestore.firestore().collection("/Users/").document(username).getDocument { (document, error) in
            if let document = document, document.exists{
                let data = document.data()
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject: data!)
                    let user = try JSONDecoder().decode(User.self, from: jsonData!)
                    self.recents = user.RecentlyViewed
                } catch {
                    print (error)
                }
            }
        }
    }
    
    func grabFirebaseData() {
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
                        self.everyBook.append(haha)
                        self.idToBook[document.documentID] = haha
                        let url = URL(string: haha.Picture)
                        let data = try? Data(contentsOf: url!)
                        let image = UIImage(data: data!)!
                        self.allImages.append(image)
                    }
                    catch{
                        print(error)
                    }
                }
            }
            self.bookResults = self.everyBook
            self.imageCache = self.allImages
            self.tableView.reloadData()
        }
    }
}

