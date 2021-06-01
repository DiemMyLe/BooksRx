//
//  BookDescriptionUseCases.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import MGArchitecture

protocol BookDescriptionUseCases {
    var dataBooksGateway: DataBooksGatewayType { get }
}

extension BookDescriptionUseCases {
    func downloadBook(fileName: String, book: Book) -> Observable<String> {
        return dataBooksGateway.downloadBook(fileName: fileName, book: book)
    }
    
    func getFileLocal(book: Book) -> Observable<URL?> {
        return dataBooksGateway.getFileLocal(book: book)
    }
    
    func isExitBookLocal(book: Book) -> Observable<Bool> {
        return dataBooksGateway.isExitBookLocal(book: book)
    }
}
