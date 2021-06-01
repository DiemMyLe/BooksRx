//
//  BookDescriptionAssembler.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol BookDescriptionAssembler {
    func resolve(navigationController: UINavigationController, book: Book) -> BookDescriptionViewController
    func resolve(navigationController: UINavigationController, book: Book) -> BookDescriptionViewModel
    func resolve(navigationController: UINavigationController) -> BookDescriptionNavigatorType
    func resolve() -> BookDescriptionUseCaseType
}

extension BookDescriptionAssembler {
    func resolve(navigationController: UINavigationController, book: Book) -> BookDescriptionViewController {
        let vc = BookDescriptionViewController.instantiate()
        let vm: BookDescriptionViewModel = resolve(navigationController: navigationController, book: book)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController, book: Book) -> BookDescriptionViewModel {
        return BookDescriptionViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve(),
            book: book)
    }
}

extension BookDescriptionAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> BookDescriptionNavigatorType {
        return BookDescriptionNavigator(assembler: self, navigatioController: navigationController)
    }
    
    func resolve() -> BookDescriptionUseCaseType {
        return BookDescriptionUseCase(dataBooksGateway: resolve())
    }
}
