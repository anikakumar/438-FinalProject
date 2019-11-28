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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.recent.dequeueReusableCell(withIdentifier: "recentlyViewed", for: indexPath)
        return cell
    }
    
    var recents: [String] = []
    var recentBooks: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        grabFirebaseData()
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
                //                    .map(String.init(describing:)) ?? "nil"
                do {
                    let jsonData = try? JSONSerialization.data(withJSONObject: data!)
                    let user = try JSONDecoder().decode(User.self, from: jsonData!)
                    self.recents = user.RecentlyViewed
                    self.grabBookData()
                } catch {
                    print ("something went wrong")
                }
            }
        }
    }
    
    func grabBookData() {
        for r in recents {
           print(r)
        }
    }
}

