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
    var imageURL: URL = URL(string: "www.google.com")!
    
//    //help from https://medium.com/@tjcarney89/accessing-camera-and-photo-library-in-swift-3-b3f075ba1702
//    @IBAction func uploadPhoto(_ sender: Any) {
//        //        let alert = UIAlertController(title: "Ready to upload?", message: nil, preferredStyle: .alert)
//        //        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
//        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
//            let imagePicker = UIImagePickerController()
//            imagePicker.delegate = self
//            imagePicker.allowsEditing = true
//            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
//            self.present(imagePicker, animated: true, completion: nil)
//        }
//        //        }))
//        //        alert.addAction(UIAlertAction(title: "No", style: .default, handler:nil))
//        //        self.present(alert, animated: true)
//    }
//    
//    /*help from https://medium.com/@tjcarney89/accessing-camera-and-photo-library-in-swift-3-b3f075ba1702           https://stackoverflow.com/questions/51342028/cannot-subscript-a-value-of-type-string-any-with-an-index-of-type-uiimage
//     */
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        
//        guard let selectedImage = info[.originalImage] as? UIImage else {
//            fatalError("\(info)")
//        }
//        self.image1.image = selectedImage
//        self.imageSet = true
//        let storageRef = Storage.storage().reference()
//        let imagesRef = storageRef.child("images")
//        let fileName = String(self.bookTitle.text! + String((Auth.auth().currentUser?.email?.dropLast(10))!)).addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!
//        let fileRef = imagesRef.child(fileName)
//        fileRef.putData(selectedImage.pngData()!)
//        fileRef.downloadURL{ url, error in
//            if let error = error {
//                print(error)
//            } else {
//                self.imageURL = url!
//            }
//        }
//        self.dismiss(animated: true, completion: nil)
//        DispatchQueue.main.async {
//            let alert = UIAlertController(title: "Uploaded!", message: nil, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Close", style: .default, handler:nil))
//            self.present(alert, animated :true)
//        }
//        
//    }
    
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
                "Author": self.author.text!,
                "BookTitle": self.bookTitle.text!,
                "Comments": self.comments.text!,
                "Condition": self.condition.text ?? "",
                "Course": self.course.text ?? "",
                "DatePosted": Timestamp(date: Date()),
                "ISBN": self.isbn.text!,
                "Picture": "https://firebasestorage.googleapis.com/v0/b/bookup-253923.appspot.com/o/images%2FNo-Photo-Available.jpg?alt=media&token=f640e4b1-c33a-4767-bf27-b4b0fce76163",
                "Price": Double(self.price.text!)!,
                "Seller": String((Auth.auth().currentUser?.email?.dropLast(10))!),
                "Version": self.version.text!,
                "Views": "0"
                ])
            let alert = UIAlertController(title: "Success!", message: "Your listing has been posted. Visit the BookUp website to upload an image.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
                NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
            
            self.bookTitle.text = ""
            self.course.text = ""
            self.price.text = ""
            self.author.text = ""
            self.condition.text = ""
            self.isbn.text = ""
            self.version.text = ""
            self.comments.text = ""
            self.emptyFields = []
            //need to reload browse
        }
    }
}

