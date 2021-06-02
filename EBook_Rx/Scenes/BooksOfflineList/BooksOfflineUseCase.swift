//
//  BooksOfflineUseCase.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 6/1/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift

protocol BooksOfflineUseCaseType {
    func getBooksOffline() -> Observable<[BookItem]>
    func deleteBook(bookItem: BookItem) -> Observable<Bool>
}

struct BooksOfflineUseCase: BooksOfflineUseCaseType, BooksOfflineUseCases {
    
    var dataBooksGateway: DataBooksGatewayType
    
    func getBooksOffline() -> Observable<[BookItem]> {
        return getBooks()
    }
    
    func deleteBook(bookItem: BookItem) -> Observable<Bool> {
        return deleteABook(bookItem: bookItem)
    }
}

