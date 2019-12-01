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
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import MessageUI

class BrowseDetails: UIViewController {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet weak var authorView: UITextField!
    @IBOutlet weak var courseView: UITextField!
    @IBOutlet weak var priceView: UITextField!
    @IBOutlet weak var conditionView: UITextField!
    @IBOutlet weak var versionView: UITextField!
    @IBOutlet weak var isbnView: UITextField!
    @IBOutlet weak var sellerView: UILabel!
    @IBOutlet weak var commView: UITextView!
    @IBOutlet weak var contactView: UIButton!
    
    var refString: String = ""
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
        image.image = bookpic
        authorView.text = a
        courseView.text = course
        isbnView.text = isbn
        versionView.text = v
        conditionView.text = cond
        commView.text = comm
        priceView.text = "$" + p
        sellerView.text = s
        let username = String((Auth.auth().currentUser?.email?.dropLast(10))!)
        if (username == s){
            contactView.setTitle("Edit your listing", for: .normal)
            deleteDisplay.isEnabled = true
        }
        else{
            contactView.setTitle("Interested? Contact seller", for: .normal)
            self.navigationItem.rightBarButtonItem = nil

        }
        contactView.setTitleColor(UIColor.red, for: .normal)
    }
    
    @IBOutlet weak var deleteDisplay: UIBarButtonItem!
    @IBAction func deleteBook(_ sender: UIBarButtonItem) {
        let db = Firestore.firestore()
        db.collection("/Postings/").document(refString).delete()
        
    }
    
    
    @IBAction func contact(_ sender: Any) {
        if contactView.titleLabel?.text == "Interested? Contact seller" {
            //https://www.hackingwithswift.com/example-code/uikit/how-to-send-an-email
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self as? MFMailComposeViewControllerDelegate
                let contactEmail = s + "@wustl.edu"
                mail.setToRecipients([contactEmail])
                mail.setMessageBody("<p>Hello! I am interested in the following item:</p><p>" + bt + "</p>", isHTML: true)
//                present(mail, animated: true)
                
                let alert = UIAlertController(title: "Success", message: "The seller has been notified via email about your interest in their listing", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                    NSLog("The \"OK\" alert occured.")
                }))
                self.present(alert, animated: true, completion: nil)
            } else {
                // show failure alert
            }
        } else {
            print ("edit")
            authorView.isUserInteractionEnabled = !authorView.isUserInteractionEnabled
            courseView.isUserInteractionEnabled = !courseView.isUserInteractionEnabled
            isbnView.isUserInteractionEnabled = !isbnView.isUserInteractionEnabled
            versionView.isUserInteractionEnabled = !versionView.isUserInteractionEnabled
            conditionView.isUserInteractionEnabled = !conditionView.isUserInteractionEnabled
            commView.isUserInteractionEnabled = !commView.isUserInteractionEnabled
            priceView.isUserInteractionEnabled = !priceView.isUserInteractionEnabled
            if (authorView.isUserInteractionEnabled) {
                contactView.setTitle("Save changes", for: .normal)
            }
            else {
                contactView.setTitle("Edit your listing", for: .normal)
//                contactView.titleLabel?.text = "Edit your listing"
            }
////            contactView.titleLabel?.text = (priceView.isUserInteractionEnabled) ? "Save changes" : "Edit your listing"
//            if contactView.titleLabel?.text == "Edit your listing" {
//                print("write to database")
////                db.collection("/Users/").document(username).updateData([
////                    "FirstName" : firstName.text!,
////                    "LastName" : lastName.text!
////                    ])
//            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
