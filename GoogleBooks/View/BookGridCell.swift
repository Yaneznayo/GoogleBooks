//
//  BookCollectionCell.swift
//  GoogleBooks
//
//  Created by Christopher Pung on 10/26/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//

import UIKit

class BookGridCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    static let identifier = "BookCell"
    
    var book: Book! {
        didSet {
            
            // Change UI labels and image
            titleLabel.text = book.title
            authorLabel.text = "by: \(book!.authors[0])"
            
            book.getImage { [weak self] img in
                self?.imageView.image = img
            }
        }
    }
    
    override func layoutSubviews() {
        
        layer.cornerRadius = 10.0
        layer.borderWidth = 0.0
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowRadius = 4.0
        layer.shadowOpacity = 0.2
        layer.masksToBounds = false
    }
}
