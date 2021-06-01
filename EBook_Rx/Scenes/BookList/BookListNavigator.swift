//
//  BookListNavigator.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol BookListNavigatorType {
    func goToBookDescription(book: Book)
}

struct BookListNavigator: BookListNavigatorType {
    unowned let assembler: Assembler
    unowned let navigationController: UINavigationController
    
    func goToBookDescription(book: Book) {
        let vc: BookDescriptionViewController = assembler.resolve(navigationController: navigationController, book: book)
        navigationController.pushViewController(vc, animated: true)
    }
}
