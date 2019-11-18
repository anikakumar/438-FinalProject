//
//  User.swift
//  BookUp
//
//  Created by Lydia on 11/18/19.
//  Copyright © 2019 Anika Kumar. All rights reserved.
//

import Foundation

struct User: Codable {
    var ProfilePic: String
    var Email: String
    var FirstName: String
    var LastName: String
    var RecentlyViewed: [String]
}
