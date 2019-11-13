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

class Browse: UIViewController, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate {
    
    @IBOutlet var search: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        search.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func searchBarSearchButtonClicked(_ search: UISearchBar) {
        if let searchText = search.text {
            //do actional
        }
    }
    

    
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
    
}

