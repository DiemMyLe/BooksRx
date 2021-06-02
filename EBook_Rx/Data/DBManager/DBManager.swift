//
//  DBManager.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

class DBManager {
    static var share = DBManager()
    
    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "\(Constants.coreDataName)")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Core Data Delete All Entity
    func deleteAllCache(entityName: String) -> Bool {
        let context = persistentContainer.viewContext
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "\(entityName)")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try context.execute(deleteRequest)
            try context.save()
            return true
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved delete error \(nserror), \(nserror.userInfo)")
        }
    }
    
    func deleteABookCache(bookItem: BookItem) -> Bool {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<BookItem>(entityName: "\(Constants.entityBookItem)")
        do {
            var listBookItems = try context.fetch(fetchRequest)
            listBookItems.removeAll { $0.id == bookItem.id }
            try context.save()
            print("delete book: \(bookItem.id)")
            return true
            
        } catch {
            print("Failed to fetch employees: \(error)")
            return false
        }
    }
    
    
    
    // MARK: - DocumentDirectory--------------
    
    func deleteAllFileDocumentDirectory() -> Bool {
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        do {
            if let documentPath = documentsPath {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    if (fileName.contains("\(Constants.keySaveBook)")) {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
                return true
            }
        } catch {
            print("Could not clear temp folder: \(error)")
            return false
        }
        return false
    }
    
    func deleteABookFromDocumentDirectory(bookItem: BookItem) -> Bool {
        let fileManager = FileManager.default
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first! as NSURL
        let documentsPath = documentsUrl.path
        do {
            if let documentPath = documentsPath {
                let fileNames = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache: \(fileNames)")
                for fileName in fileNames {
                    if (fileName.contains("\(Constants.keySaveBook)\(bookItem.id)")) {
                        let filePathName = "\(documentPath)/\(fileName)"
                        try fileManager.removeItem(atPath: filePathName)
                    }
                }
                let files = try fileManager.contentsOfDirectory(atPath: "\(documentPath)")
                print("all files in cache after deleting images: \(files)")
                return true
            }
        } catch {
            print("Could not clear temp folder: \(error)")
            return false
        }
        return false
    }
    
    
    func getFileDocumentDirectory(fileName: String) -> URL? {
        do {
            let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
            for url in contents {
                if url.description.contains("\(fileName).pdf") {
                    return url
                }
            }
        } catch {
            print("could not locate pdf file !!!!!!!")
        }
        return nil
    }
    
    // check to avoid saving a file multiple times
    func isPDFFileAlreadySaved(url:String, fileName:String) -> Bool {
        var status = false
        if #available(iOS 10.0, *) {
            do {
                let docURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                let contents = try FileManager.default.contentsOfDirectory(at: docURL, includingPropertiesForKeys: [.fileResourceTypeKey], options: .skipsHiddenFiles)
                for url in contents {
                    if url.description.contains("\(fileName)") {
                        status = true
                    }
                }
            } catch {
                print("could not locate pdf file !!!!!!!")
            }
        }
        return status
    }
    
    func downloadBookAndSaveLocal(fileName: String, book: Book) -> Observable<String> {
        
        return Observable.create { (observer) in
            let request = URLRequest(url: URL(string: book.pdf_url)!)
            let config = URLSessionConfiguration.default
            let session =  URLSession(configuration: config)
            let task = session.dataTask(with: request, completionHandler: {(data, response, error) in
                if error == nil{
                    if let pdfData = data {
                        let pathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(fileName).pdf")
                        do {
                            try pdfData.write(to: pathURL, options: .atomic)
                            print("path:...\(pathURL)")
                            
                            //save to coredata
                            let bookManaged = BookItem(context: self.persistentContainer.viewContext)
                            bookManaged.id = Int32(book.id)
                            bookManaged.title = book.title
                            bookManaged.author = book.author
                            bookManaged.pdfURL = book.pdf_url
                            bookManaged.urlImageBook = book.thumbnail
                            bookManaged.pages = book.pages
                            
                            DBManager.share.saveContext()
                            print("did save: \(book.id)_\(book.title)")
                            
                            observer.onNext("")
                            observer.onCompleted()
                        }catch{
                            print("Error while writting!")
                            observer.onNext("Error while writting!")
                            observer.onCompleted()
                        }
                    }
                }else{
                    print(error?.localizedDescription ?? "")
                    observer.onNext(error?.localizedDescription ?? "")
                    observer.onCompleted()
                }
            })
            task.resume()
            return Disposables.create()
        }
    }
    ///Fetch data
    func fetchBooks() -> Observable<[BookItem]> {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<BookItem>(entityName: "\(Constants.entityBookItem)")
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Constants.entityBookItem)
        
        return Observable.create { (observer) in
            do {
                let listBookItems = try context.fetch(fetchRequest)
                observer.onNext(listBookItems)
                observer.onCompleted()
                
            } catch {
                print("Failed to fetch employees: \(error)")
                observer.onError(error)
            }
            
            return Disposables.create()
        }
        
    }
}
