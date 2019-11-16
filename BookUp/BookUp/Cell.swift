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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    public func configure(i: UIImage, l1:String,l2:String,l3:String,id:Int){
        imageV.image = i
        label1.text = l1
        label2.text = l2
        label3.text = l3
        self.id = id
    }
}
