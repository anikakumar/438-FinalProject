//
//  ViewController.swift
//  BookUp
//
//  Created by Anika Kumar on 11/8/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

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
    
    //TODO @shadi - this grabData func needs to be an action from a button click or search entered
//       func grabData(_, sender: Any){
//           grabFirebaseData()
//       }
    
    func grabFirebaseData() {
        let ref = Database.database().reference()
        ref.observe(.value, with: {
            snapshot in
            print("\(snapshot.key) -> \(String(describing: snapshot.value))")
            //our data is more complex than just a dict of string to string
            let someData = snapshot.value! as! Dictionary<String, Book>
            
            for (_, value) in someData {
                print("Value is \(value)")
                //TODO UNCOMMENT
                self.bookResults.append(value)
                
            }
            //TODO UNCOMMENT
            //self.collectionView.reloadData()
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       //testing
        grabFirebaseData()
        // Do any additional setup after loading the view.
    }


    
}

