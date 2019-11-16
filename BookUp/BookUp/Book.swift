//
//  Book.swift
//  BookUp
//
//  Created by Lydia on 11/15/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import Foundation

struct Book: Decodable {
    let BookTitle: String!
    let Author: String?
    let Comments: String?
    let Course: String?
    let Price: String?
    let ISBN: String?
    //let DatePosted: Date?
    let Condition: String?
    let Seller: String?
    let Version: String?
    //let Views: String?
}
