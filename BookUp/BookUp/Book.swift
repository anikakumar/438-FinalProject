//
//  Book.swift
//  BookUp
//
//  Created by Lydia on 11/15/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import Foundation

struct Book: Codable {
    var BookTitle: String
    var Author: String
    var Comments: String
    var Course: String
    var Price: Int
    let ISBN: String
    let Condition: String
    var Seller: String
    let Version: String
    //let Views: String?
    let Picture: String
}
