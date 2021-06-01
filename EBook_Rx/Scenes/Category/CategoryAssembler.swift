//
//  CategoryAssembler.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol CategoryAssembler {
    func resolve(navigationController: UINavigationController) -> CategoryViewController
    func resolve(navigationController: UINavigationController) -> CategoryViewModel
    func resolve(navigationController: UINavigationController) -> CategoryNavigatorType
    func resolve() -> CategoryUseCaseType
}

extension CategoryAssembler {
    func resolve(navigationController: UINavigationController) -> CategoryViewController {
        let vc = CategoryViewController.instantiate()
        let vm: CategoryViewModel = resolve(navigationController: navigationController)
        vc.bindViewModel(to: vm)
        return vc
    }
    
    func resolve(navigationController: UINavigationController) -> CategoryViewModel {
        return CategoryViewModel(
            navigator: resolve(navigationController: navigationController),
            useCase: resolve())
    }
}

extension CategoryAssembler where Self: DefaultAssembler {
    func resolve(navigationController: UINavigationController) -> CategoryNavigatorType {
        return CategoryNavigator(assembler: self, navigationController: navigationController)
    }
    
    func resolve() -> CategoryUseCaseType {
        return CategoryUseCase(dataBooksGateway: resolve())
    }
}
