//
//  BooksOfflineNavigator.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 6/1/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol BooksOfflineNavigatorType {
    //
}

struct BooksOfflineNavigator: BooksOfflineNavigatorType {
    unowned let assembler: Assembler
    unowned let navigatioController: UINavigationController
}
