//
//  FavViewController.swift
//  GoogleBooks
//
//  Created by Christopher Pung on 10/27/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//

import UIKit

class FavoriteVC: SearchVC {
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        loadBooks()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadBooks()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }

    
    // MARK: - Functions
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailVC {
            detailVC.book = currentBook!
        }
    }
    
    private func loadBooks() {
        let favBooks = BookManager.shared.load()
        let bks = BookManager.shared.convertToBookArray(from: favBooks)
        books = bks.reversed()
    }
    
}


// MARK: - View Delegate Flow Layout
extension FavoriteVC {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentBook = books[indexPath.row]
        performSegue(withIdentifier: "segueFromFavorites", sender: (Any).self)
    }
    
}
