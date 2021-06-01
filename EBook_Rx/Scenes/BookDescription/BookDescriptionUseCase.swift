//
//  BookDescriptionUseCase.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift

protocol BookDescriptionUseCaseType {
    func donwloadBook(fileName: String, book: Book) -> Observable<String>
    func getBookFile(book: Book) -> Observable<URL?>
    func isExitBook(book: Book) -> Observable<Bool>
}

struct BookDescriptionUseCase: BookDescriptionUseCaseType, BookDescriptionUseCases {
    var dataBooksGateway: DataBooksGatewayType
    
    func donwloadBook(fileName: String, book: Book) -> Observable<String> {
        return downloadBook(fileName: fileName, book: book)
    }
    
    func getBookFile(book: Book) -> Observable<URL?> {
        return getFileLocal(book: book)
    }
    
    func isExitBook(book: Book) -> Observable<Bool> {
        return isExitBookLocal(book: book)
    }
}

