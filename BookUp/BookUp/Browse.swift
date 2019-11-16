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


class Browse: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var search: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    var bookResults: [Book] = []
    var b: Book!
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
 
    func grabFirebaseData() {
        let db = Firestore.firestore()
        
        //let ref = Database.database().reference()
        //let ref = db.collection("/Postings/")
        /*ref.observe(.value, with: {
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
         })*/
        db.collection("/Postings/").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    var m =  document.data() as [String:AnyObject]
                    m.removeValue(forKey: "DatePosted")
                    let jsonData = try? JSONSerialization.data(withJSONObject:m)
                    //print(type(of: jsonData))
                    /*var messageDictionary = [String]()

                    for (key, value) in m {
                        messageDictionary.append("\(key) \(value)")
                    }
                    print(type(of: messageDictionary))*/
                    /*let jsonData = try! JSONSerialization.data(withJSONObject: m)
                    print(jsonData)*/
                    do{
                        let haha = try JSONDecoder().decode(Book.self, from: jsonData!)
                        print(haha)
                    }
                    catch{
                        print("nooooooo")
                    }
                    //let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
                   // do{
                   /*     let dict = jsonString.toJSON() as? [String:AnyObject] // can be any type here
                    }
                    catch{
                        print("err")
                    }*/
                    //print("success")
                    //let dataExample: Data = try NSKeyedArchiver.archivedData(withRootObject: document.data()) as Data
                    //let jsonData = try JSONDecoder().decode(Book.self, from: dataExample)
                    //print(jsonData.title)
                    //let jsonString = String(data: jsonData, encoding: .utf8)
                    //print(jsonString)
                    //print(self.b.title ?? "DOESN'T WORK")
//                    print("\(document.documentID) => \(document.data())")
                    }
            }
        }
    }
}

