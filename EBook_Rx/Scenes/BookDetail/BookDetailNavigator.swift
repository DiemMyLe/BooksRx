//
//  BookDetailNavigator.swift
//  EBook_Rx
//
//  Created by le.thi.diem.my on 5/31/21.
//  Copyright © 2021 DiemMy Le. All rights reserved.
//

import UIKit

protocol BookDetailNavigatorType {
    //
}

struct BookDetailNavigator: BookDetailNavigatorType {
    unowned let assembler: Assembler
    unowned let navigator: UINavigationController
}
