//
//  DetailViewController.swift
//  GoogleBooks
//
//  Created by Christopher Pung on 10/27/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//

import UIKit

class DetailVC: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    

    var book: Book?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up book
        titleLabel.text = book!.title
        authorsLabel.text = book!.authors[0]
        
        // Set image
        book!.getImage { [weak self] img in
            self?.imageView.image = img
        }
        
        // Configure Button
        book!.isFavorite ? changeButtonToGray() : changeButtonToBlue()
        configureButton()
        
    }
    
    @IBAction func addToFavoriteButtonTapped(_ sender: UIButton) {
        favoriteButton.backgroundColor == .gray ? removeFromFavorite() : addToFavorite()
    }
    
    // MARK: - Functions
    private func configureButton() {
        favoriteButton.layer.cornerRadius = 20
        favoriteButton.layer.shadowColor = UIColor.black.cgColor
        favoriteButton.layer.shadowOffset = CGSize(width: 0, height: 1.0)
        favoriteButton.layer.shadowRadius = 4.0
        favoriteButton.layer.shadowOpacity = 0.2
        favoriteButton.layer.masksToBounds = false
    }
    
    private func setButtonColor() {
        if book!.isFavorite {
            changeButtonToGray()
        } else {
            changeButtonToBlue()
        }
    }
    
    private func addToFavorite() {
        changeButtonToGray()
        BookManager.shared.save(book!)
    }
    
    private func removeFromFavorite() {
        changeButtonToBlue()
        let favBooks = BookManager.shared.load()
        
        for favBook in favBooks where favBook.id == book!.id {
            BookManager.shared.delete(favBook)
        }
    }
    
    private func changeButtonToBlue() {
        favoriteButton.backgroundColor = .blue
        favoriteButton.setTitle("Add To Favorites", for: .normal)
    }
    
    private func changeButtonToGray() {
        favoriteButton.backgroundColor = .gray
        favoriteButton.setTitle("Added To Favorites", for: .normal)
    }
    

}
