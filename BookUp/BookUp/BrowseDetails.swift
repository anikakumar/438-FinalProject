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
import MessageUI

class BrowseDetails: UIViewController {
    
    @IBOutlet var image: UIImageView!
//    @IBOutlet var name: UILabel!
    //var book: Book!
    var bt: String = ""
    var a: String = ""
    var course: String = ""
    var p: String = ""
    var s: String = ""
    var comm: String = ""
    var cond: String = ""
    var v: String = ""
    var isbn: String = ""
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
        
        let authorFrame = CGRect(x: 0, y: 510, width: view.frame.width, height: 30)
        let authorView = UILabel(frame: authorFrame)
        authorView.text = "Author: " + a
        authorView.textAlignment = .center
        view.addSubview(authorView)
        
        let courseFrame = CGRect(x: 0, y: 540, width: view.frame.width, height: 30)
        let courseView = UILabel(frame: courseFrame)
        courseView.text = "Course: " + course
        courseView.textAlignment = .center
        view.addSubview(courseView)
        
        let isbnFrame = CGRect(x: 0, y: 570, width: view.frame.width, height: 30)
        let isbnView = UILabel(frame: isbnFrame)
        isbnView.text = "ISBN: " + isbn
        isbnView.textAlignment = .center
        view.addSubview(isbnView)
        
        let versionFrame = CGRect(x: 0, y: 600, width: view.frame.width, height: 30)
        let versionView = UILabel(frame: versionFrame)
        versionView.text = "Version: " + v
        versionView.textAlignment = .center
        view.addSubview(versionView)
        
        let conditionFrame = CGRect(x: 0, y: 630, width: view.frame.width, height: 30)
        let conditionView = UILabel(frame: conditionFrame)
        conditionView.text = "Condition: " + cond
        conditionView.textAlignment = .center
        view.addSubview(conditionView)
        
        let commFrame = CGRect(x: 0, y: 660, width: view.frame.width, height: 30)
        let commView = UILabel(frame: commFrame)
        commView.text = "Comments: " + comm
        commView.textAlignment = .center
        view.addSubview(commView)
        
        let priceFrame = CGRect(x: 0, y: 690, width: view.frame.width, height: 30)
        let priceView = UILabel(frame: priceFrame)
        priceView.text = "Price: $" + p
        priceView.textAlignment = .center
        view.addSubview(priceView)
        
        let sellerFrame = CGRect(x: 0, y: 720, width: view.frame.width, height: 30)
        let sellerView = UILabel(frame: sellerFrame)
        sellerView.text = "Seller: " + s
        sellerView.textAlignment = .center
        view.addSubview(sellerView)
        
        let contactFrame = CGRect(x: view.frame.midX - 180, y: 450, width: 360, height: 30)
        let contactView = UIButton(frame: contactFrame)
        let username = String((Auth.auth().currentUser?.email?.dropLast(10))!)
        if (username == s){
            contactView.setTitle("This is your listing", for: .normal) 
            contactView.layer.borderWidth = 0
        }
        else{
            contactView.setTitle("Interested? Contact seller", for: .normal)
            contactView.layer.borderWidth = 1
        }
        contactView.setTitleColor(UIColor.red, for: .normal)

        contactView.layer.cornerRadius = 8
        view.addSubview(contactView)
        //https://stackoverflow.com/questions/27371194/set-action-listener-programmatically-in-swift
        if (username != s){
            contactView.addTarget(self, action: #selector(contact), for: .touchUpInside)
        }
    }

    @objc func contact() {
        //https://www.hackingwithswift.com/example-code/uikit/how-to-send-an-email
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
            let contactEmail = s + "@wustl.edu"
            mail.setToRecipients([contactEmail])
            mail.setMessageBody("<p>Hello! I am interested in the following item:</p><p>" + bt + "</p>", isHTML: true)
            present(mail, animated: true)
        } else {
            // show failure alert
        }
//
//        let alert = UIAlertController(title: "Success", message: "The seller has been notified via email about your interest in their listing", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
//            NSLog("The \"OK\" alert occured.")
//        }))
//        self.present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
