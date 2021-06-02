//
//  BooksOfflineUseCases.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 6/1/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//
import UIKit
import RxSwift
import MGArchitecture

protocol BooksOfflineUseCases {
    var dataBooksGateway: DataBooksGatewayType { get }
}

extension BooksOfflineUseCases {
    func getBooks() -> Observable<[BookItem]> {
        return dataBooksGateway.getBooks()
    }
    
    func deleteABook(bookItem: BookItem) -> Observable<Bool> {
        return dataBooksGateway.deleteABook(bookItem: bookItem)
    }
}
