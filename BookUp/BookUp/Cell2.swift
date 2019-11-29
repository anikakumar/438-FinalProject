//
//  Cell2.swift
//  BookUp
//
//  Created by Davari on 11/28/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import Foundation
import UIKit

class Cell2: UICollectionViewCell {
    
    @IBOutlet var image: UIImageView!
    @IBOutlet var label: UILabel!
    
    public func configure(i: UIImage, l:String){
        image.image = i
        self.label.text = l
    }
}
