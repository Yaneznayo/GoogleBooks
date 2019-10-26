//
//  BookModel.swift
//  GoogleBooks
//
//  Created by Christopher Pung on 10/26/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//

import Foundation

struct Book: Decodable {
    let title: String
    let authors: [String]
    
}
//json!["items"]["volumeInfo"]["title"].stringValue
