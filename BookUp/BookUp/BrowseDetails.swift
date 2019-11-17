//
//  BrowseDetails.swift
//  BookUp
//
//  Created by Davari on 11/11/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.

//image
//title of book
//author
//course
//condition
//version/edition
//description/additional notes
//contact seller button
//isbn (maybe)

import Foundation
import UIKit

class BrowseDetails: UIViewController {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var name: UILabel!
    //var book: Book!
    
    var bt: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print("bt" + bt)
        navigationItem.title = bt
        
    }

    @IBAction func contact(_ sender: Any) {
        let alert = UIAlertController(title: "The seller has been notified via email about your interest in their listing.", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    }
}

