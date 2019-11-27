//
//  Post.swift
//  BookUp
//
//  Created by Davari on 11/11/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

//GOT HELP FROM SHADI'S LAB

import Foundation
import UIKit
import Photos
import MobileCoreServices
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

class Post: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var emptyFields: [String] = []
    var imageSet = false

    @IBOutlet weak var image1: UIImageView!

    @IBOutlet var bookTitle: UITextField!
    
    @IBOutlet var course: UITextField!
    
    @IBOutlet var price: UITextField!
    
    @IBOutlet var author: UITextField!
    
    @IBOutlet var condition: UITextField!
    
    @IBOutlet var isbn: UITextField!
    
    @IBOutlet var version: UITextField!
    
    @IBOutlet var comments: UITextField!

    
    //help from https://medium.com/@tjcarney89/accessing-camera-and-photo-library-in-swift-3-b3f075ba1702
    @IBAction func uploadPhoto(_ sender: Any) {
//        let alert = UIAlertController(title: "Ready to upload?", message: nil, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
//        }))
//        alert.addAction(UIAlertAction(title: "No", style: .default, handler:nil))
//        self.present(alert, animated: true)
    }
    
    /*help from https://medium.com/@tjcarney89/accessing-camera-and-photo-library-in-swift-3-b3f075ba1702           https://stackoverflow.com/questions/51342028/cannot-subscript-a-value-of-type-string-any-with-an-index-of-type-uiimage
     */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("\(info)")
        }
        image1.image = selectedImage
        imageSet = true
        dismiss(animated: true, completion: nil)
        let alert = UIAlertController(title: "Uploaded!", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Close", style: .default, handler:nil))
        self.present(alert, animated :true)
    }
    
    @IBAction func post(_ sender: Any) {
        if bookTitle.text == ""{
            emptyFields.append("Book Title")
        }
        if course.text == ""{
            emptyFields.append("Course")
        }
        if price.text == ""{
            emptyFields.append("Price")
        }
        if author.text == ""{
            emptyFields.append("Author")
        }
        if condition.text == ""{
            emptyFields.append("Condition")
        }
        if isbn.text == ""{
            emptyFields.append("ISBN")
        }
        if (!imageSet){
            emptyFields.append("Picture")
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
        } else {
            Firestore.firestore().collection("/Postings/").addDocument(data: [
                "Author": author.text!,
                "BookTitle": bookTitle.text!,
                "Comments": comments.text!,
                "Condition": condition.text ?? "",
                "Course": course.text ?? "",
                "DatePosted": Timestamp(date: Date()),
                "ISBN": isbn.text!,
                "Picture": "https://firebasestorage.googleapis.com/v0/b/bookup-253923.appspot.com/o/images%2Fphysics2.jpg?alt=media&token=7778b141-6f3d-4183-8160-426d14cf46cc", //this needs to be fixed
                "Price": Int(price.text!)!,
                "Seller": String((Auth.auth().currentUser?.email?.dropLast(10))!),
                "Version": version.text!,
                "Views": "0"
                ])
            let alert = UIAlertController(title: "Success!", message: "Your listing has been posted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            image1.image = nil
            bookTitle.text = ""
            course.text = ""
            price.text = ""
            author.text = ""
            condition.text = ""
            isbn.text = ""
            version.text = ""
            comments.text = ""
            //need to reload browse
            
        }
    }
    

    //submit form
        //upload image
        //title of book
        //author
        //course
        //condition
        //version/edition
        //description/additional notes
    //post button
    //auto grabs seller id
}

