//
//  BookModel.swift
//  GoogleBooks
//
//  Created by Christopher Pung on 10/26/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//

import Foundation
import UIKit

typealias ImageHandler = (UIImage?) -> Void

struct Book: Decodable {
    let authors: [String]
    let id: String
    let image: String
    var isFavorite: Bool
    let title: String

func getImage(completion: @escaping ImageHandler) {
        
        guard let url = URL(string: image) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url ) { (dat, _, _) in
            if let data = dat {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            }
        }.resume()
    }
}
    
//json!["items"]["volumeInfo"]["title"].stringValue
