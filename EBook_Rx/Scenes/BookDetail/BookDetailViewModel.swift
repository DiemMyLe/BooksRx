//
//  BookDetailViewModel.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 5/31/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import MGArchitecture


struct BookDetailViewModel: ViewModel {
    let navigator: BookDetailNavigatorType
    let useCase: BookDetailUseCaseType
    let book: Book
    let urlBookLocal: URL
}

extension BookDetailViewModel {
    
    struct Input {
        var loadTrigger: Driver<Void>
    }
    
    struct Output {
        var openBookURL: Driver<URL>
    }
    
    func transform(_ input: Input, disposeBag: DisposeBag) -> Output {
        let openBookURL = input.loadTrigger
            .map({ self.urlBookLocal })
        
        return Output(openBookURL: openBookURL)
    }
    
}
