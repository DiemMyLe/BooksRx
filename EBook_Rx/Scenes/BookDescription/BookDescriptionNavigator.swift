//
//  BookDescriptionNavigator.swift
//  EBook_Rx
//
//  Created by DiemMy Le on 5/30/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol BookDescriptionNavigatorType {
    func goToBookDetail(book: Book, url: URL)
}

struct BookDescriptionNavigator: BookDescriptionNavigatorType {
    unowned let assembler: Assembler
    unowned let navigatioController: UINavigationController
    
    func goToBookDetail(book: Book, url: URL) {
        let vc:BookDetailViewController = assembler.resolve(navigationController: navigatioController, book: book, urlBookLocal: url)
        navigatioController.pushViewController(vc, animated: true)
    }
}
