//
//  Cell.swift
//  ViewControllerDemo
//
//  Created by Davari on 10/14/19.
//  Copyright © 2019 Todd Sproull. All rights reserved.
//

import Foundation
import UIKit

class Cell: UITableViewCell {
    
    @IBOutlet var imageV: UIImageView!
    @IBOutlet var label1: UILabel!
    @IBOutlet var label2: UILabel!
    @IBOutlet var label3: UILabel!
    var id: Int!
  
    public func configure(i: UIImage, l1:String,l2:String,l3:String,id:Int){
        //imageV.image = i
        //print(l1 + "l1")
        self.label1.text = l1
        self.label2.text = l2
        self.label3.text = l3
    }
}
