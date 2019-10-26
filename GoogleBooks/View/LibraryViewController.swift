//
//  ViewController.swift
//  GoogleBooks
//
//  Created by Christopher Pung on 10/26/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//

import UIKit
import SwiftyJSON

extension UIView {
    func setupToFill(superView: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(self)
        leadingAnchor.constraint(equalTo: superView.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: superView.trailingAnchor).isActive = true
        topAnchor.constraint(equalTo: superView.layoutMarginsGuide.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
    }
}

class LibraryViewController: UIViewController {
    
    var titles = [String]()
    let session = URLSession(configuration: .default)
    lazy var gridView: UICollectionView = {
        let grid = UICollectionView()
        grid.dataSource = self as! UICollectionViewDataSource
        grid.register(UITableViewCell.self, forCellWithReuseIdentifier: "cell")
           return grid
       }()
    func getTitles(){
        let url = "https://www.googleapis.com/books/v1/volumes?q="
        session.dataTask(with: URL(string: url)!) { (data, _, _) in
            guard let data = data else { return }
            let json = try? JSON(data: data)
            //alternate method
            /*for i in 0..<json!.count{
                self.titles.append(json![i]["title"].stringValue)
            }*/
            for (_ ,subJson):(String, JSON) in json! {
                self.titles.append(subJson["title"].stringValue)
            }
            DispatchQueue.main.async {
                self.gridView.reloadData()
            }
        }.resume()


    }
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
    }
}

/*extension LibraryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        <#code#>
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        <#code#>
    }
    
    func gridView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return vm.count
    }
    
    func gridView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell",
                                                      for: indexPath) as! PokeImageCollectionViewCell
        vm.image(at: indexPath.row) { (dat) in
            guard let dat = dat else { return }
            let image = UIImage(data: dat)
            DispatchQueue.main.async {
                cell.imageView.image = image
            }
        }
        
        return cell
    }
    
}

*/
