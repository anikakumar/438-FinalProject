//
//  Book.swift
//  
//
//  Created by Lydia on 11/15/19.
//

import Foundation

struct Book: Decodable {
    let title: String?
    let author: String?
    let comment: String?
    let condition: String?
    let course: String?
    let price: Double?
    let ISBN: String?
    let image_path: String?
    let seller: String?
    let version: Double?
    let views: Int?
}
