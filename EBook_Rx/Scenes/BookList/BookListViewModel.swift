//
//  BookListViewModel.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MGArchitecture

struct BookListViewModel: ViewModel {
    let navigator: BookListNavigatorType
    let useCase: BookListUseCaseType
    let category: Category
}

extension BookListViewModel {
    
    struct Input {
        var loadTrigger: Driver<Void>
        var selectBookTrigger: Driver<IndexPath>
    }
    
    struct Output {
        var category: Driver<Category>
        var book: Driver<Book>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let category = input.loadTrigger
            .map({self.category})
        
        let books = category.map({$0.books})
        let book = select(trigger: input.selectBookTrigger, items: books)
            .do(onNext: { (book) in
                self.navigator.goToBookDescription(book: book)
            })
        
        return Output(category: category, book: book)
    }
    
}
