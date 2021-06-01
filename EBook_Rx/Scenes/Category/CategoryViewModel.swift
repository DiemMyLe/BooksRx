//
//  CategoryViewModel.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MGArchitecture

struct CategoryViewModel: ViewModel {
    let navigator: CategoryNavigatorType
    let useCase: CategoryUseCaseType
}

extension CategoryViewModel {
    
    struct Input {
        var loadTrigger: Driver<Void>
        var selectCategoryTrigger: Driver<IndexPath>
        var deleteAllBookTrigger: Driver<Void>
    }
    
    struct Output {
        var listCategories: Driver<[Category]>
        var categoryItem: Driver<Category>
        var isDeleteAllBookSuccess: Driver<Bool>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        
        let listCategories = input.loadTrigger
            .flatMapLatest { (_) -> Driver<[Category]> in
                return self.useCase.getListCategories(fileName: "\(Constants.jsonFileName)").asDriverOnErrorJustComplete()
        }
        
        let cateItem = select(trigger: input.selectCategoryTrigger, items: listCategories)
            .do(onNext: { (cate) in
                self.navigator.goToBookList(category: cate)
            })
        
        let statusDeleteAllBooks = input.deleteAllBookTrigger
            .flatMapLatest { (_) -> Driver<Bool> in
                return self.useCase.deleteAllBooks().asDriverOnErrorJustComplete()
            }
        
        return Output(listCategories: listCategories,
                      categoryItem: cateItem,
                      isDeleteAllBookSuccess: statusDeleteAllBooks)
    }
}
