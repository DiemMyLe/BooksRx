//
//  BookDescriptionViewModel.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MGArchitecture

struct BookDescriptionViewModel: ViewModel {
    let navigator: BookDescriptionNavigatorType
    let useCase: BookDescriptionUseCaseType
    let book: Book
}

extension BookDescriptionViewModel {
    
    struct Input {
        var loadTrigger: Driver<Void>
        var downloadTrigger: Driver<Void>
        var readingTrigger: Driver<Void>
    }
    
    struct Output {
        var book: Driver<Book>
        var downloadError: Driver<String>
        var readingBook: Driver<URL>
        var isExitBook: Driver<Bool>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        //load book
        let book = input.loadTrigger
            .map({ self.book })
        
        let isExitBook = input.loadTrigger.withLatestFrom(useCase.isExitBook(book: self.book).asDriverOnErrorJustComplete())
        
        //download
        let downloadError = input.downloadTrigger
            .map({ self.book })
            .flatMapLatest { (book) -> Driver<String> in
                return self.useCase.donwloadBook(fileName: "bookid\(book.id)", book: book).asDriverOnErrorJustComplete()
        }
        
        //reading
        //go to book detail
        let openBookFile = input.readingTrigger
            .map({ self.book })
            .flatMapLatest { (book) -> Driver<URL> in
                return self.useCase.getBookFile(book: book)
                    .unwrap()
                    .asDriverOnErrorJustComplete()
        }
        .do(onNext: { (urlBook) in
            self.navigator.goToBookDetail(book: self.book, url: urlBook)
        })
        
        return Output(book: book,
                      downloadError: downloadError,
                      readingBook: openBookFile,
                      isExitBook: isExitBook)
    }
}
