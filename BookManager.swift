//
//  BookManager.swift
//  GoogleBooks
//
//  Created by Christopher Pung on 10/27/19.
//  Copyright © 2019 Mobile Apps Company. All rights reserved.
//

import Foundation
import UIKit
import CoreData

typealias BookHandler = ([Book]) -> Void

// Singleton
final class BookManager {
    
    // MARK: - Singleton Stack
    static let shared = BookManager()
    private init() {}
    
    
    // MARK: - Properties
        // Persistent Container
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "GoogleBooks")
        
        container.loadPersistentStores(completionHandler: { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        })
        return container
    }()
    
        // Set up Managed Object Context
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    
    // MARK: - Public functions
    func getBooks(for term: String, completion: @escaping BookHandler) {
        
        // Checking url with optional binding
        guard let url = Endpoint(searchTerm: term).getUrl() else {
            completion ([])
            return
        }
        
        // Create URL Session
        URLSession.shared.dataTask(with: url) { (dat, _, err) in
            
            var books = [Book]()
            
            // Checking if any error
            if let error = err {
                print("API Request Failed: \(error.localizedDescription)")
                completion([])
                return
            }
            
            // Check data
            guard let data = dat else { return }
            
            // JSON Serialization
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let bookItems = json["items"] as? [[String: Any]]
                
                for item in bookItems! {
                    let book = self.parseJSON(from: item)
                    books.append(book)
                }
                
                // Pass '[Book]' back through completion (main thread)
                DispatchQueue.main.async {
                    completion(books)
                }
                
            } catch {
                print("Unable to serialized: \(error.localizedDescription)")
                completion([])
                return
            }
    
        }.resume()
    }


    func convertToBookArray(from favBooks: [FavBook]) -> [Book] {
        var books = [Book]()
    
        for favBook in favBooks {
            let book = Book(authors: [favBook.authors!], id: favBook.id!, image: favBook.image!, isFavorite: favBook.isFavorite, title: favBook.title!)
        
            books.append(book)
        }
        return books
    }


    // MARK: - Private functions
    private func parseJSON(from item: [String: Any]) -> Book {
    
        // Nested JSON Elements
        let info: [String: Any] = item["volumeInfo"] as! [String: Any]
        let images: [String: Any] = (info["imageLinks"] as? [String: Any])!
    
        // Exctracting variables
        let id = item["id"] as? String ?? ""
        let title = info["title"] as? String ?? ""
        let image = images["thumbnail"] as? String ?? ""
        let authors = info["authors"] as? [String] ?? ["N/A"]
        
        // Creating Book instance
        let book = Book(authors: authors, id: id, image: image, isFavorite: false, title: title)
    
        return book
    }

    private func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }

    private func check(_ book: Book) {
        let favBooks = load()
    
        for favBook in favBooks where favBook.id == book.id {
            context.delete(favBook)
            return
        }
    }


    // MARK: - CoreData CRUD Operations
        // CREATE
    func save(_ book: Book) {
        check(book)
        
        let entity = NSEntityDescription.entity(forEntityName: "FavBook", in: context)!
        let favBook = FavBook(entity: entity, insertInto: context)
        
            //KVC
        favBook.setValue(book.id, forKey: "id")
        favBook.setValue(book.title, forKey: "title")
        favBook.setValue(book.authors[0], forKey: "authors")
        favBook.setValue(book.image, forKey: "image")
        favBook.setValue(true, forKey: "isFavorite")
        
        saveContext()
        
        print("\(book.title) by \(book.authors[0]) saved in Favorites!")
    }
    
        // READ
    func load() -> [FavBook] {
        let fetchRequest = NSFetchRequest<FavBook>(entityName: "FavBook")
        var favBooks = [FavBook]()
        
        do {
            favBooks = try context.fetch(fetchRequest)
        } catch {
            print("Couldn't Fetch Favorite Books: \(error.localizedDescription)")
        }

        return favBooks
    }
    
        // DELETE
    func delete(_ favBook: FavBook) {
        context.delete(favBook)
        print("Favorite book deleted: \(favBook.title!), by \(favBook.authors!)")
        
        saveContext()
    }
    
    func deleteAll() {
        let favBooks = load()
        
        for favBook in favBooks {
            context.delete(favBook)
        }
        print("\(favBooks.count) book\(favBooks.count > 1 ? "s" : "") deleted from Favorites!")
        
        saveContext()
    }


}
