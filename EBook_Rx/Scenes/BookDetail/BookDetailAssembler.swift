//
//  BookDetailAssembler.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 5/31/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol BookDetailAssembler {
    func resolve(navigationController: UINavigationController, book: Book, urlBookLocal: URL) -> BookDetailViewController
    func resolve(navigationController: UINavigationController, book: Book, urlBookLocal: URL) -> BookDetailViewModel
    func resolve(navigationController: UINavigationController) -> BookDetailNavigatorType
    func resolve() -> BookDetailUseCaseType
}

extension BookDetailAssembler {
    func resolve(navigationController: UINavigationController, book: Book, urlBookLocal: URL) -> BookDetailViewController {
        let vc = BookDetailViewController.instantiate()
        let vm: BookDetailViewModel = resolve(navigationController: navigationController, book: book, urlBookLocal: urlBookLocal)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, book: Book, urlBookLocal: URL) -> BookDetailViewModel {
        return BookDetailViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            book: book,
            urlBookLocal: urlBookLocal)
    }
}

extension BookDetailAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> BookDetailNavigatorType {
        return BookDetailNavigator(assembler: self, navigatioController: navigationController)
    }
    
    func resolve() -> BookDetailUseCaseType {
        return BookDetailUseCase()
    }
}
