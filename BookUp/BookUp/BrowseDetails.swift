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
import FirebaseAuth

class BrowseDetails: UIViewController {
    
    @IBOutlet var image: UIImageView!
//    @IBOutlet var name: UILabel!
    //var book: Book!
    var bt: String = ""
    var a: String = ""
    var course: String = ""
    var p: String = ""
    var s: String = ""
    var bookpic: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white

        navigationItem.title = bt
        
        //change y values to move them up and down
        let imageFrame = CGRect(x: 107, y: 120, width: 200,
                                height: 300)
        let imageView = UIImageView(frame: imageFrame)
        imageView.image = bookpic
        view.addSubview(imageView)
        
        let authorFrame = CGRect(x: 0, y: 320, width: view.frame.width, height: 30)
        let authorView = UILabel(frame: authorFrame)
        authorView.text = "Author: " + a
        authorView.textAlignment = .center
        view.addSubview(authorView)
        
        let courseFrame = CGRect(x: 0, y: 360, width: view.frame.width, height: 30)
        let courseView = UILabel(frame: courseFrame)
        courseView.text = "Course: " + course
        courseView.textAlignment = .center
        view.addSubview(courseView)
        
        let priceFrame = CGRect(x: 0, y: 400, width: view.frame.width, height: 30)
        let priceView = UILabel(frame: priceFrame)
        priceView.text = "Price: $" + p
        priceView.textAlignment = .center
        view.addSubview(priceView)
        
        let sellerFrame = CGRect(x: 0, y: 440, width: view.frame.width, height: 30)
        let sellerView = UILabel(frame: sellerFrame)
        sellerView.text = "Seller: " + s
        sellerView.textAlignment = .center
        view.addSubview(sellerView)
        
        let contactFrame = CGRect(x: view.frame.midX - 180, y: 510, width: 360, height: 30)
        let contactView = UIButton(frame: contactFrame)
        contactView.setTitle("Interested? Contact seller", for: .normal)
        contactView.setTitleColor(UIColor.red, for: .normal)
        contactView.layer.borderWidth = 1
        contactView.layer.cornerRadius = 8
        view.addSubview(contactView)
        //https://stackoverflow.com/questions/27371194/set-action-listener-programmatically-in-swift
        contactView.addTarget(self, action: #selector(contact), for: .touchUpInside)
        
    }

    @objc func contact() {
        let alert = UIAlertController(title: "Success", message: "The seller has been notified via email about your interest in their listing", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
