//
//  BooksOfflineViewModel.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 6/1/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MGArchitecture

struct BooksOfflineViewModel: ViewModel {
    let navigator: BooksOfflineNavigatorType
    let useCase: BooksOfflineUseCaseType
}

extension BooksOfflineViewModel {
    
    struct Input {
        var loadTrigger: Driver<Void>
//        var deleteBookTrigger: Driver<BookItem>
        var deleteBookTrigger: Driver<IndexPath>
    }
    
    struct Output {
        var listBooksOffline: Driver<[BookItem]>
        var isDeleteBook: Driver<Bool>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let listBooksBehavior = BehaviorRelay(value: [BookItem]())
        
        let books = input.loadTrigger
            .flatMapLatest { (_) -> Driver<[BookItem]> in
                return self.useCase.getBooksOffline().asDriverOnErrorJustComplete()
            }
            .do { (list) in
                listBooksBehavior.accept(list)
            }

        
        // deleteBook
//        let deleteStatus = input.deleteBookTrigger
//            .flatMapLatest { (bookItem) -> Driver<Bool> in
//                return self.useCase.deleteBook(bookID: "\(Constants.keySaveBook)\(bookItem.id)")
//                    .asDriverOnErrorJustComplete()
//            }
//            .withLatestFrom(books)
//            .flatMapLatest { (_) -> Driver<[BookItem]> in
//                return self.useCase.getBooksOffline().asDriverOnErrorJustComplete()
//            }
        let itemDelete = Driver.combineLatest(input.deleteBookTrigger, books)
        
        let deleteStatus = itemDelete
            .flatMapLatest { (indexPath, list) -> Driver<Bool> in
                let item = list[indexPath.row]
                let status = self.useCase.deleteBook(bookItem: item)
                    .asDriverOnErrorJustComplete()
                let newList = list.filter({$0.id != item.id})
                listBooksBehavior.accept(newList)
                return status
            }

        
        return Output(listBooksOffline: listBooksBehavior.asDriverOnErrorJustComplete(), isDeleteBook: deleteStatus)
    }
}
