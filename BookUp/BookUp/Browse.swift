//
//  Browse.swift
//  BookUp
//
//  Created by Davari on 11/11/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase


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


class Browse: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var search: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    var bookResults: [Book] = []
    
    struct Book: Decodable {
        let title: String?
        let author: String?
        let comment: String?
        let condition: String?
        let course: String?
        let price: Double?
        let ISBN: String?
        let image_path: String?
        let seller: String?
        let version: Double?
        let views: Int?
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        grabFirebaseData()
        // Do any additional setup after loading the view.
    }
    
    /*func searchBarSearchButtonClicked(_ search: UISearchBar) {
        if let searchText = search.text {
            //do actional
        }
    }*/
    
    @IBAction func grabData(_ sender: Any) {
        grabFirebaseData()
    }
    
    func grabFirebaseData() {
        let ref = Database.database().reference()
        ref.child("/Postings/").observe(.value, with: {
            snapshot in
            print("\(snapshot.key) -> \(String(describing: snapshot.value))")
            //our data is more complex than just a dict of string to string
            let someData = snapshot.value! as! Dictionary<String, Book>
            
            for (_, value) in someData {
                print("Value is \(value)")
                //TODO UNCOMMENT
                self.bookResults.append(value)
                
            }
            self.tableView.reloadData()
        })
    }
}

