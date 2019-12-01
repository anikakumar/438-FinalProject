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
    var Price: Double
    let ISBN: String
    let Condition: String
    var Seller: String
    let Version: String
    //let Views: String?
    let Picture: String
}

extension Book: Equatable {
    static func ==(lhs: Book, rhs: Book) -> Bool {
        guard lhs.BookTitle == rhs.BookTitle else {
            return false
        }
        guard lhs.Author == rhs.Author else {
            return false
        }
        guard lhs.Comments == rhs.Comments else {
            return false
        }
        guard lhs.Course == rhs.Course else {
            return false
        }
        guard lhs.Price == rhs.Price else {
            return false
        }
        guard lhs.ISBN == rhs.ISBN else {
            return false
        }
        guard lhs.Seller == rhs.Seller else {
            return false
        }
        guard lhs.Version == rhs.Version else {
            return false
        }
        guard lhs.Picture == rhs.Picture else {
            return false
        }
        return true
    }
}
