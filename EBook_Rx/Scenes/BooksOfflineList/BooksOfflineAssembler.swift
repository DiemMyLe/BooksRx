//
//  BooksOfflineAssembler.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 6/1/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol BooksOfflineAssembler {
    func resolve(navigationController: UINavigationController) -> BooksOfflineViewController
    func resolve(navigationController: UINavigationController) -> BooksOfflineViewModel
    func resolve(navigationController: UINavigationController) -> BooksOfflineNavigatorType
    func resolve() -> BooksOfflineUseCaseType
}

extension BooksOfflineAssembler {
    func resolve(navigationController: UINavigationController) -> BooksOfflineViewController {
        let vc = BooksOfflineViewController.instantiate()
        let vm: BooksOfflineViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> BooksOfflineViewModel {
        return BooksOfflineViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve())
    }
}

extension BooksOfflineAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> BooksOfflineNavigatorType {
        return BooksOfflineNavigator(assembler: self, navigatioController: navigationController)
    }
    
    func resolve() -> BooksOfflineUseCaseType {
        return BooksOfflineUseCase(dataBooksGateway: resolve())
    }
}



