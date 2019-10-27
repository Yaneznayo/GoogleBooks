//
//  Endpoint.swift
//  GoogleBooks
//
//  Created by Christopher Pung on 10/27/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//


import Foundation

struct Endpoint {
    
    let base = "https://www.googleapis.com/books/v1/volumes?q="
    let searchTerm: String
    
    func getUrl() -> URL? {
        return URL(string: base + convertToUrl(from: searchTerm))!
    }
    
    private func convertToUrl(from search: String) -> String {
        let newString = search.replacingOccurrences(of: " ", with: "+")
        return newString
    }
    
}
