//
//  BookListAssembler.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol BookListAssembler {
    func resolve(navigationController: UINavigationController, category: Category) -> BookListViewController
    func resolve(navigationController: UINavigationController, category: Category) -> BookListViewModel
    func resolve(navigationController: UINavigationController) -> BookListNavigatorType
    func resolve() -> BookListUseCaseType
}

extension BookListAssembler {
    func resolve(navigationController: UINavigationController, category: Category) -> BookListViewController {
        let vc = BookListViewController.instantiate()
        let vm: BookListViewModel = resolve(navigationController: navigationController, category: category)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, category: Category) -> BookListViewModel {
        return BookListViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(), category: category)
    }
}

extension BookListAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> BookListNavigatorType {
        return BookListNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> BookListUseCaseType {
        return BookListUseCase()
    }
}
