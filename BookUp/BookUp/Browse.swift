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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:Cell = self.tableView.dequeueReusableCell(withIdentifier: "myBook", for: indexPath) as! Cell
       // let imageURL = URL(string: bookResults[indexPath.row].Picture!)
        //let imageURL = URL(fileURLWithPath: "noImage.png")
        //let imageData = try? Data(contentsOf:imageURL)
        //let image = UIImage(data: imageData!)!
        let image = UIImage(named: "noImage.png")!
        print(bookResults[indexPath.row].BookTitle + " j")
        print(bookResults[indexPath.row].Course + "j")
        cell.configure(i: image, l1: bookResults[indexPath.row].BookTitle, l2: bookResults[indexPath.row].Course , l3: bookResults[indexPath.row].Price, id: indexPath.row)
        return cell
    }
    

    
    @IBOutlet var search: UISearchBar!
    
    @IBOutlet var tableView: UITableView!
    var bookResults: [Book] = []
    var b: Book!
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        grabFirebaseData()
        self.tableView.isHidden = false
        self.tableView.reloadData()
        //print(self.bookResults.count)
        // Do any additional setup after loading the view.
    }

    /*override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }*/
    
    func searchBar(_ search: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload), object: nil)
        self.perform(#selector(self.reload), with: nil, afterDelay: 0.5)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(120)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.performSegue(withIdentifier: "myBook", sender: indexPath)
       // guard let indexPath = sender as? IndexPath else { return }
        let detailVC = BrowseDetails()
//        print(bookResults[indexPath.row].BookTitle)
//        do {
//        let title:String = bookResults[indexPath.row].BookTitle as String
//            print(type(of: bookResults[indexPath.row].BookTitle))
//        detailVC.name.text = bookResults[indexPath.row].BookTitle
        print(bookResults[indexPath.row].BookTitle)
        detailVC.bt = bookResults[indexPath.row].BookTitle
//            detailVC.name.text = title
//        }
//        else {
//            let title:String = "not found"
//            detailVC.name.text = title
//        }
        
//        detailVC.book = bookResults[indexPath.row] as Book
        /*if  let result = bookResults[indexPath.row]{
         if let title = result.BookTitle {
         detailVC.name.text = title
         }
         }*/
            
//        print(bookResults[indexPath.row])
        
        
//        detailVC.name.text = bookResults[indexPath.row].BookTitle
        //detailVC?.image = imageCache[indexPath.row] as UIImage
        navigationController?.pushViewController(detailVC, animated: true)
        
    }
    
    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "myBook") {
            guard let indexPath = sender as? IndexPath else { return }
            let detailVC = segue.destination as? BrowseDetails
            //detailVC?.name.text = bookResults[indexPath.row].BookTitle
            detailVC?.book = bookResults[indexPath.row] as Book
            //detailVC?.image = imageCache[indexPath.row] as UIImage
        }
    }*/
    
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
                    }
                    catch{
                        print("nooooooo")
                    }
                }
            }
            print(self.bookResults.count)
//            print(self.bookResults[5].BookTitle as String)
            self.tableView.reloadData()
        }
    }
    
    @objc func reload() {
        tableView.reloadData()
        //let searchText = search.text
        DispatchQueue.global(qos: .userInitiated).async {
            self.grabFirebaseData()
            //self.cacheImages()
            DispatchQueue.main.async{
                print(self.bookResults.count)
                self.tableView.reloadData()
            }
        }
    }
}

