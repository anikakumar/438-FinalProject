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
        priceView.text = p
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
        let alert = UIAlertController(title: "Success", message: "The posting has been deleted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
    }
    
    //https://stackoverflow.com/questions/40887721/sending-an-email-from-swift-3
    func mailComposeController(controller: MFMailComposeViewController,
                               didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        // Check the result or perform other tasks.
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
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
                present(mail, animated: true)
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
                var emptyFields: [String] = []
                if courseView.text == ""{
                    emptyFields.append("Course")
                }
                if priceView.text == ""{
                    emptyFields.append("Price")
                }
                if authorView.text == ""{
                    emptyFields.append("Author")
                }
                if conditionView.text == ""{
                    emptyFields.append("Condition")
                }
                if isbnView.text == ""{
                    emptyFields.append("ISBN")
                }
                if (emptyFields.count != 0){
                    var message = ""
                    for field in emptyFields{
                        message = message + field + ", "
                    }
                    let index = message.index(message.endIndex, offsetBy: -2)
                    let message2 = String(message.prefix(upTo: index))
                    emptyFields = []
                    let alert = UIAlertController(title: "Empty Fields!", message: message2, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                    }))
                    self.present(alert, animated: true, completion: nil)
                    authorView.isUserInteractionEnabled = !authorView.isUserInteractionEnabled
                    courseView.isUserInteractionEnabled = !courseView.isUserInteractionEnabled
                    isbnView.isUserInteractionEnabled = !isbnView.isUserInteractionEnabled
                    versionView.isUserInteractionEnabled = !versionView.isUserInteractionEnabled
                    conditionView.isUserInteractionEnabled = !conditionView.isUserInteractionEnabled
                    commView.isUserInteractionEnabled = !commView.isUserInteractionEnabled
                    priceView.isUserInteractionEnabled = !priceView.isUserInteractionEnabled
                } else {
                    Firestore.firestore().collection("/Postings/").document(refString).updateData([
                    "Author": self.authorView.text!,
                    "Comments": self.commView.text!,
                    "Condition": self.conditionView.text ?? "",
                    "Course": self.courseView.text ?? "",
                    "ISBN": self.isbnView.text!,
                    "Price": Double(self.priceView.text!)!,
                    "Version": self.versionView.text!,
                    ])
                    contactView.setTitle("Edit your listing", for: .normal)
                }
            }
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
