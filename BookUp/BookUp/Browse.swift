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

//main parts:
//Search bar
//how to filter queries by isbn, course, title???
//UICollectionView or UITableView
//default is by recently added
//on click goes to detailed view
//cache images
//book titles

//optional:
//filtered search


class Browse: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource {

    
    @IBOutlet var search: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    var bookResults: [Book] = []
    var b: Book!
    override func viewDidLoad() {
        super.viewDidLoad()
//        search.delegate = self
//        tableView.register(Cell.self, forCellReuseIdentifier: "myBook")
        tableView.delegate = self
        tableView.dataSource = self
        grabFirebaseData()
//        tableView.reloadData()
        // Do any additional setup after loading the view.
    }

    /*func searchBarSearchButtonClicked(_ search: UISearchBar) {
     if let searchText = search.text {
     //do actional
     }
     }*/
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookResults.count
        //search - count
        //otherwise - 15 latest
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:Cell = self.tableView.dequeueReusableCell(withIdentifier: "myBook", for: indexPath) as! Cell
        let imageURL = URL(string: bookResults[indexPath.row].Picture!)
        let imageData = try? Data(contentsOf:imageURL!)
        let image = UIImage(data: imageData!)!
//        cell.imageV.image = image
//        cell.label1.text = bookResults[indexPath.row].BookTitle
//        cell.label2.text = bookResults[indexPath.row].Course
//        cell.label3.text = bookResults[indexPath.row].Price
        
//        cell.configure(i: image, l1: bookResults[indexPath.row].BookTitle, l2: bookResults[indexPath.row].Course ?? "N/A", l3: bookResults[indexPath.row].Price ?? "N/A", id: indexPath.row)
//        cell.textLabel!.text = bookResults[indexPath.row].BookTitle
//        cell.selectionStyle = .none
        
        return cell
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
                        self.bookResults.append(haha)
//                        print(haha)
                    }
                    catch{
                        print("nooooooo")
                    }
                }
            }
            //print(self.bookResults.count)
            //print(self.bookResults[5].BookTitle as String)
        }
    }
}

