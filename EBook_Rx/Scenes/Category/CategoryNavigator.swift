//
//  CategoryNavigator.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol CategoryNavigatorType {
    func goToBookList(category: Category)
    func goToBooksOffline()
}

struct CategoryNavigator: CategoryNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func goToBookList(category: Category) {
        let vc: BookListViewController = assembler.resolve(navigationController: navigationController, category: category)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func goToBooksOffline() {
        let vc: BooksOfflineViewController = assembler.resolve(navigationController: navigationController)
        navigationController.pushViewController(vc, animated: true)
    }
}
