//
//  DataBooksGateway.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import MGArchitecture
import ObjectMapper

protocol DataBooksGatewayType {
    func getCategoriesJson(fileName: String) -> Observable<[Category]>
    func downloadBook(fileName: String, book: Book) -> Observable<String>
    func deleteAllBookLocal() -> Observable<Bool>
    func getFileLocal(book: Book) -> Observable<URL?>
    func isExitBookLocal(book: Book) -> Observable<Bool>
    func getBooks() -> Observable<[BookItem]>
    func deleteABook(bookItem: BookItem) -> Observable<Bool>
}

struct DataBooksGateway: DataBooksGatewayType {
    
    func getCategoriesJson(fileName: String) -> Observable<[Category]> {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let json = object as? [String: AnyObject] {
                    let categoriesDict = Categories(JSON: json)
                    let mData = Observable.from(optional: categoriesDict?.arrCategories ?? [])
                    return mData
                }
            } catch {
                print("Error!! Unable to parse  \(fileName).json")
            }
        }
        return Observable.from([])
    }
    
    func downloadBook(fileName: String, book: Book) -> Observable<String> {
        return DBManager.share.downloadBookAndSaveLocal(fileName: fileName, book: book)
    }
    
    func deleteAllBookLocal() -> Observable<Bool> {
        let statusDeleteAll = DBManager.share.deleteAllCache(entityName: "\(Constants.entityBookItem)") && DBManager.share.deleteAllFileDocumentDirectory()
        return Observable.just(statusDeleteAll)
    }
    
    func getFileLocal(book: Book) -> Observable<URL?> {
        let url = DBManager.share.getFileDocumentDirectory(fileName: "\(Constants.keySaveBook)\(book.id)")
        return Observable.just(url)
    }
    
    func isExitBookLocal(book: Book) -> Observable<Bool> {
        let status = DBManager.share.isPDFFileAlreadySaved(url: book.pdf_url, fileName: "\(Constants.keySaveBook)\(book.id)")
        return Observable.just(status)
    }
    
    func getBooks() -> Observable<[BookItem]> {
        return DBManager.share.fetchBooks()
    }
    
    func deleteABook(bookItem: BookItem) -> Observable<Bool> {
        let status = DBManager.share.deleteABookFromDocumentDirectory(bookItem: bookItem) &&
            DBManager.share.deleteABookCache(bookItem: bookItem)
        return Observable.just(status)
    }
}
